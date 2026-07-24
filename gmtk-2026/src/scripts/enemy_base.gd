extends CharacterBody3D
class_name EnemyBase

@export var speed: float
var target_velocity = Vector3.ZERO
var player: Node3D

func _ready() -> void:
	player = %player

func _physics_process(delta: float) -> void:
	return

func _enemy_move():
	velocity = target_velocity
	move_and_slide()
