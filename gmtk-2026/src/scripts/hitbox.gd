class_name Hitbox
extends Area3D

var current_damage: DamageInfo
var hit_targets := {}


func _on_body_entered(body: Node3D) -> void:
	if body in hit_targets:
		return

	hit_targets[body] = true
	if (body is EnemyBase):
		body.get_child(0).take_damage(current_damage)
	#print("Hit:", body.name)

func reset():
	hit_targets.clear()
