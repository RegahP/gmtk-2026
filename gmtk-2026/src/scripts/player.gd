extends CharacterBody3D
class_name Player

@onready var attack_controller: AttackController = $AttackController
@onready var anim: AnimationPlayer = $pivot/nivamodel/AnimationPlayer
@export var speed: float
var target_velocity = Vector3.ZERO

var dead: bool = false
var stunned: bool = false
var is_attacking: bool = false

@onready var meshes: Array[MeshInstance3D] = [
	$pivot/nivamodel/rig/Skeleton3D/TORSO_001,
	$pivot/nivamodel/rig/Skeleton3D/TORSO_004]

func _ready() -> void:
	anim.play("idle")

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
		if (!is_attacking):
			anim.play("walkanim")
		direction = direction.normalized()
		attack_controller.weapon.basis = Basis.looking_at(direction)
		$pivot.basis = Basis.looking_at(direction)
	else:
		if (!is_attacking):
			anim.play("idle")
		
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
		anim.play("attackanim")
		is_attacking = true
		await get_tree().create_timer(attack_controller.attackData.attack_windup).timeout
		_attack_enemy()

func _attack_enemy() -> void:
	attack_controller.attack()
	await get_tree().create_timer(attack_controller.attackData.attack_cooldown).timeout
	is_attacking = false

func take_damage(damage: DamageInfo): # esta funcion la invoca enemy al atacar exitosamente a player
	get_parent()._timer_reduce(damage.amount)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	for mesh in meshes:
		mesh.set_surface_override_material(0, mat)
		mesh.set_surface_override_material(1, mat)
	await get_tree().create_timer(.1).timeout
	for mesh in meshes:
		mesh.set_surface_override_material(0, null)
		mesh.set_surface_override_material(1, null)

func stun(duration: float):
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false
