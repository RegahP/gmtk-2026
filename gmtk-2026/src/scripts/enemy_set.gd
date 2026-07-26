extends Node3D

var enemies: Array[Node3D]
var setCount: int

signal enemies_cleared()

func _ready() -> void:
	for enemy in get_children():
		if (enemy is EnemyBase):
			enemies.append(enemy)
			enemy.died.connect(_on_died_count)
			if (enemy is FleshMound):
				enemy.birthed.connect(_on_birthed_count)
	setCount = enemies.size()

func _set_enemies(player: Node3D) -> void:
	for enemy in enemies:
		enemy.player = player

func _on_died_count() -> void:
	setCount -= 1
	if (setCount - 1 < 0):
		enemies_cleared.emit()
		print("open doors!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

func _on_birthed_count(enemy: Node3D) -> void:
	setCount += 1
	enemies.append(enemy)
	enemy.died.connect(_on_died_count)
