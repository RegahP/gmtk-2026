class_name AttackController
extends Node

@export var attackData: AttackData
@onready var weapon: Weapon = $"../Weapon"

func attack():
	
	weapon.attack(attackData)
