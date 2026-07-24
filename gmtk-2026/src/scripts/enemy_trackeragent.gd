extends EnemyBase

var head: Node3D

func _ready() -> void:
	super()
	head = $"mobmodel_TRACKER_AGENT/tracker agent"

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= attack_range:
		if (is_moving):
			_attack_windup()
	
	if is_moving:
		var direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		
		var target_pos = player.global_position
		var my_pos = head.global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		head.global_rotation.y = angle - 89.5
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
		_enemy_move()
	else:
		target_velocity = Vector3.ZERO
