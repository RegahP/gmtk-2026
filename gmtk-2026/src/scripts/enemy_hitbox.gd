class_name EnemyHitbox
extends Area3D

var current_damage: DamageInfo
@export var hit_targets := {}


func _on_body_entered(body: Node3D) -> void:
	if body in hit_targets:
		return
	
	hit_targets[body] = true
	if (body is Player):
		body.take_damage(current_damage)

func reset():
	hit_targets.clear()
