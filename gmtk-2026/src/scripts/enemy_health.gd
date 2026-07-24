class_name EnemyHealth  
extends Node

@export var max_health: float = 100

var current_health: float

func _ready():
	current_health = max_health

func take_damage(damage: DamageInfo): # esta funcion la invoca player para atacar exitosamente a enemy
	if (current_health - damage.amount > 0):
		current_health -= damage.amount
	else:
		current_health = 0
		die() 

func deal_damage(damage: DamageInfo): # esta funcion la invoca enemy al atacar exitosamente a player
	get_parent().get_parent()._timer_reduce(damage.amount)

func die():
	print("%s died!" % owner.name)
	
	owner.queue_free()
