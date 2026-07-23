extends EnemyBase

var head: Node3D

func _ready() -> void:
	super()
	head = $"mobmodel_TRACKER_AGENT/tracker agent"

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if (player != null):
		direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		var target_pos = player.global_position
		var my_pos = head.global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		head.global_rotation.y = angle - 89.5
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
		velocity = target_velocity
		
		move_and_slide()
