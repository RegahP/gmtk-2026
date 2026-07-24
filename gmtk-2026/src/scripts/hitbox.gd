class_name Hitbox
extends Area3D

var current_damage: DamageInfo
var hit_targets := {}


func _on_body_entered(body: Node3D) -> void:
	if body in hit_targets:
		return

	hit_targets[body] = true

	var health = body.get_node_or_null("Health")

	if health == null:
		return

	health.take_damage(current_damage)
	print("Hit:", body.name)
