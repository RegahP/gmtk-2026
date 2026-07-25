extends Node3D

func _set_enemies(player: Node3D) -> void:
	for enemy in get_children():
		if (enemy is EnemyBase):
			enemy.player = player
