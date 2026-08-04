extends EnemyBase
class_name Homunculard

var body: Node3D
var time: float

var acceleration: float

func _ready() -> void:
	super()
	body = $homunculard
	time += randf()
	acceleration = 1
	animation = $homunculard/AnimationPlayer
	attack_controller.animation = animation

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
	
	if distance <= enable_range && !attack_controller._is_attacking():
		var dist = global_position.distance_to(player.global_position)
		if dist > 2: return
		
		var direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		
		var target_pos = player.global_position
		var my_pos = global_position
		
		
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		global_rotation.y = angle
		
		acceleration += delta
		animation.play("walkanim", -1, acceleration)
		target_velocity.x = direction.x * (speed * acceleration) + sin(time * 2) * .15
		target_velocity.z = direction.z * (speed * acceleration) + sin(time * 3) * .15
		
		_enemy_move()
	else:
		target_velocity = Vector3.ZERO
		acceleration = 1
