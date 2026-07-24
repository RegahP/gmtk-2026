extends EnemyBase

var body: Node3D
var time: float
var is_moving := true
@export var attack_range: float = .25
@export var attack_cooldown: float = .5

func _ready() -> void:
	super()
	body = $fleshbud
	time += randf()

func _process(delta: float) -> void:
	time += delta
	var scale_factor = Vector3(
		1.0 + sin(time * 3) * .1,
		1.0 + sin(.33 + time * 3) * .1,
		1.0 + sin(.66 + time * 3) * .1)
	body.scale = scale_factor

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance <= attack_range:
		_attack_player()
	else:
		is_moving = true

	if is_moving:
		var direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()

		var target_pos = player.global_position
		var my_pos = body.global_position

		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		body.global_rotation.y = angle
		attack_controller.weapon.rotation.y = angle
		
		target_velocity.x = direction.x * speed + sin(time * 2) * .15
		target_velocity.z = direction.z * speed + sin(time * 3) * .15
		
		_enemy_move()
	else:
		target_velocity = Vector3.ZERO
		
func _attack_player() -> void:
	is_moving = false
	
	attack_controller.attack()
	await get_tree().create_timer(attack_cooldown).timeout
	
	is_moving = true
	
