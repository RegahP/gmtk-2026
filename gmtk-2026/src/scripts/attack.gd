extends Node3D
class_name Attack

@export var data: AttackData

var is_attacking: bool
@export var is_passive: bool

@onready var hurtbox: Area3D = $Hurtbox
@onready var attackbox: Area3D = $Attackbox
@export var hitbox: Area3D

signal autocasted()
signal attempted()
signal landed()
signal missed()
signal ended()

func _ready() -> void:
	if (is_passive):
		attackbox.player_entered.connect(_on_player_entered)

func _on_player_entered() -> void:
	autocasted.emit()

func _windup() -> bool:
	if (!is_attacking):
		is_attacking = true
		if hitbox: hitbox.monitorable = true
		attempted.emit()
		get_tree().create_timer(data.windup).timeout.connect(_attack)
		return true
	return false

func _attack() -> void:
	attackbox.monitoring = false
	if (hurtbox._deal_damage(data)):
		landed.emit()
	else:
		missed.emit()
	await get_tree().create_timer(data.cooldown).timeout
	is_attacking = false
	attackbox.monitoring = true
	if hitbox: hitbox.monitorable = false
	ended.emit()

func _is_passive() -> bool:
	return is_passive
