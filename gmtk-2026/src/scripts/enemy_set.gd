extends Node3D

var enemies: Array[Node3D]
var setCount: int

func _ready() -> void:
	for enemy in get_children():
		if (enemy is EnemyBase):
			enemies.append(enemy)
			enemy.died.connect(_on_died_count)
	setCount = enemies.size()

func _set_enemies(player: Node3D) -> void:
	for enemy in enemies:
		enemy.player = player

func _on_died_count() -> void:
	setCount -= 1
	if (setCount - 1 < 0):
		print("open doors!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
