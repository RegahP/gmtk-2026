class_name EnemyHealth  
extends Node

@export var max_health: float = 100

var current_health: float
var main

func _ready():
	current_health = max_health

func take_damage(damage: DamageInfo):
	main._timer_reduce(damage.amount)

func die():
	print("%s died!" % owner.name)
	
	owner.queue_free()
