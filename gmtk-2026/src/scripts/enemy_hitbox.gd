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
		if get_parent().get_parent() is ProjectileBase:
			get_parent().get_parent().queue_free()
		if get_parent().get_parent() is Homunculard:
			body.stun(.5)

func reset():
	hit_targets.clear()
