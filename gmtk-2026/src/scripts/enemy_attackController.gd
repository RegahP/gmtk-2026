class_name EnemyAttackController
extends Node

@export var light_attack: AttackData
@onready var weapon: EnemyWeapon = $"../Weapon"

func attack():
	#print("AttackController")
	weapon.attack(light_attack)
