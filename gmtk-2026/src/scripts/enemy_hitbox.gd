class_name EnemyHitbox
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

	health.deal_damage(current_damage)
	print("Hit:", body.name)

func reset():
	hit_targets.clear()
