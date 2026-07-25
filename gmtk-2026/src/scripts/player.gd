extends CharacterBody3D
class_name Player

@onready var attack_controller: AttackController = $AttackController
@export var speed: float
var target_velocity = Vector3.ZERO

var dead: bool = false
var stunned: bool = false
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	var attackdir = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		direction.z -= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		direction.z += 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		direction.x -= 1
		
	if Input.is_action_pressed("attack_right"):
		attackdir.x += 1
		attackdir.z -= 1
	if Input.is_action_pressed("attack_left"):
		attackdir.x -= 1
		attackdir.z += 1
	if Input.is_action_pressed("attack_back"):
		attackdir.z += 1
		attackdir.x += 1
	if Input.is_action_pressed("attack_forward"):
		attackdir.z -= 1
		attackdir.x -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		attack_controller.weapon.basis = Basis.looking_at(direction)
		$pivot.basis = Basis.looking_at(direction)
		
	if attackdir != Vector3.ZERO:
		_attack_windup()
		attackdir = attackdir.normalized()
		attack_controller.weapon.basis = Basis.looking_at(attackdir)
		$pivot.basis = Basis.looking_at(attackdir)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if !dead:
		if !stunned:
			velocity = target_velocity
			move_and_slide()

func _on_timer_timeout() -> void:
	dead = true;

func _attack_windup() -> void:
	if (!is_attacking):
		#print("ATTACKING ENEMY")
		is_attacking = true
		await get_tree().create_timer(attack_controller.attackData.attack_windup).timeout
		_attack_enemy()

func _attack_enemy() -> void:
	attack_controller.attack()
	await get_tree().create_timer(attack_controller.attackData.attack_cooldown).timeout
	is_attacking = false

func take_damage(damage: DamageInfo): # esta funcion la invoca enemy al atacar exitosamente a player
	get_parent()._timer_reduce(damage.amount)

func stun(duration: float):
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false
