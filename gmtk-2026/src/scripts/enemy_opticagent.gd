extends EnemyBase

var time: float

func _ready() -> void:
	super()
	time += randf()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= enable_range:
		if !attack_controller._is_attacking():
			var direction = global_position.direction_to(player.global_position)
			direction = direction.normalized()
			
			time += delta
			var sine = 1.0 + sin(time * 4)
			
			var target_pos = player.global_position
			var my_pos = global_position
			var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
			global_rotation.y = angle
			
			target_velocity.x = direction.x * speed * sine
			target_velocity.z = direction.z * speed * sine
		
			_enemy_move()
		else:
			target_velocity = Vector3.ZERO
