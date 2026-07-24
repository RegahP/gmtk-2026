class_name PlayerHealth  
extends Node

@export var max_health: float = 100

var current_health: float


func _ready():
	current_health = max_health

func take_damage(damage: DamageInfo):
	current_health -= damage.amount
	
	print("%s took %.1f damage. HP: %.1f" % [
		owner.name,
		damage.amount,
		current_health
	])
	
	if current_health <= 0:
		die()

func die():
	print("%s died!" % owner.name)
	
	owner.queue_free()
