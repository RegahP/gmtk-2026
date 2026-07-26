extends EnemyBase
class_name Homunculard

var body: Node3D
var time: float

var acceleration: float

func _ready() -> void:
	super()
	body = $homunculardwb
	time += randf()
	acceleration = 1

func _process(delta: float) -> void:
	time += delta
	var scale_factor = Vector3(
		1.0 + sin(time * 3) * .1,
		1.0 + sin(.33 + time * 3) * .1,
		1.0 + sin(.66 + time * 3) * .1)
	body.scale = scale_factor * .2

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance <= attack_range:
		if (is_moving):
			_attack_windup()
	
	if is_moving:
		var dist = global_position.distance_to(player.global_position)
		if dist > 2: return
		
		var direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()

		var target_pos = player.global_position
		var my_pos = body.global_position
		

		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		body.global_rotation.y = angle
		attack_controller.weapon.rotation.y = angle
		
		acceleration += delta
		target_velocity.x = direction.x * (speed * acceleration) + sin(time * 2) * .15
		target_velocity.z = direction.z * (speed * acceleration) + sin(time * 3) * .15
		
		_enemy_move()
	else:
		target_velocity = Vector3.ZERO
		acceleration = 1
