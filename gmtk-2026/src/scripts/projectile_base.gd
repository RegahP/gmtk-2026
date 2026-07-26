extends CharacterBody3D
class_name ProjectileBase

@export var speed: float
var target_velocity = Vector3.ZERO
var player: Node3D

@onready var attack_controller: EnemyAttackController = $AttackController

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance <= .3:
		_attack_player()
	if distance > 3:
		queue_free()

	var forward_dir = -global_transform.basis.z
	velocity = forward_dir * speed
	move_and_slide()
	
func _attack_player() -> void:
	attack_controller.attack()
