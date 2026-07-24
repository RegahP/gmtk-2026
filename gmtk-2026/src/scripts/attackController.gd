class_name AttackController
extends Node

@export var light_attack: AttackData
@onready var weapon: Weapon = $"../Weapon"

func attack():
	print("AttackController")
	weapon.attack(light_attack)
