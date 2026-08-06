extends CharacterBody3D
class_name ProjectileBase

@export var speed: float
var target_velocity = Vector3.ZERO
var player: Node3D

@onready var attack_controller: EnemyAttackController = $EnemyAttackController

func _ready() -> void:
	attack_controller.attack_landed.connect(_destroy)

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance > 3:
		_destroy()

	var forward_dir = -global_transform.basis.z
	velocity = forward_dir * speed
	move_and_slide()
	
func _destroy() -> void:
	queue_free()
