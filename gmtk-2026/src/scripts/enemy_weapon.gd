class_name EnemyWeapon
extends Node3D

@onready var hitbox: EnemyHitbox = $Hitbox

var current_attack: AttackData

func _ready() -> void:
	hitbox.body_entered.connect(hitbox._on_body_entered)

func attack(data: AttackData):

	if data == null:
		push_error("Weapon.attack() was called without an AttackData!")
		return
	
	hitbox.reset()

	var damage := DamageInfo.new()

	damage.amount = data.damage
	damage.attacker = owner

	hitbox.current_damage = damage

	hitbox.monitoring = true
	#print("hitbox enabled")
	
	await get_tree().physics_frame
	
	#print("Bodies:", hitbox.get_overlapping_bodies())

	await get_tree().create_timer(0.2).timeout

	hitbox.monitoring = false
	#print("hitbox disabled")
	
