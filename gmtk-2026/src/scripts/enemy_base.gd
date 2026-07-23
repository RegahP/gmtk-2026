extends CharacterBody3D
class_name EnemyBase

@export var health: float
@export var speed: float
var target_velocity = Vector3.ZERO
var player: Node3D

func _ready() -> void:
	player = %player

func _take_damage(amount: float) -> void:
	if (health - amount > 0):
		health -= amount
	else:
		health = 0

func _physics_process(delta: float) -> void:
	return
