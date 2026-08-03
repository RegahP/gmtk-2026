extends Area3D

@export var hit_targets: Array[Node3D] = []

func _deal_damage(attackData: AttackData) -> bool:
	for target in hit_targets:
		target.take_damage(attackData.damage)
		return true
	return false

func _on_body_entered(body: Node3D) -> void:
	if (body in hit_targets):
		return
	if (body is Player):
		hit_targets.append(body)

func _on_body_exited(body: Node3D) -> void:
	if (body in hit_targets):
		hit_targets.erase(body)
