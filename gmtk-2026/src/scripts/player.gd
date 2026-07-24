extends CharacterBody3D

@onready var attack_controller: AttackController = $AttackController
@export var speed: float
var target_velocity = Vector3.ZERO

var dead: bool = false;

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
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
		
	if Input.is_action_just_pressed("Attack"):
		attack_controller.attack()
		print("Attack")
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$pivot.basis = Basis.looking_at(direction)
		#attack_controller.weapon.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if !dead:
		velocity = target_velocity
		move_and_slide()

func _on_timer_timeout() -> void:
	dead = true;
