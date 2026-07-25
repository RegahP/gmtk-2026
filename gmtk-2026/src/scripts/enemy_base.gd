extends CharacterBody3D
class_name EnemyBase

@export var speed: float
var target_velocity = Vector3.ZERO
var player: Node3D

var is_moving := true
@export var attack_range: float
@export var attack_windup: float
@export var attack_cooldown: float

@onready var health: EnemyHealth = $Health
@onready var attack_controller: EnemyAttackController = $AttackController

signal died()

func _ready() -> void:
	health.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	return

func _enemy_move():
	velocity = target_velocity
	move_and_slide()

func _attack_windup() -> void:
	#print("ATTACKING PLAYER")
	is_moving = false
	await get_tree().create_timer(attack_windup).timeout
	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		_attack_player()
	else:
		is_moving = true

func _attack_player() -> void:
	#print("ATTACK CONNECTED")
	attack_controller.attack()
	await get_tree().create_timer(attack_cooldown).timeout
	is_moving = true

func _on_died() -> void:
	died.emit()
