extends EnemyBase

var body: Node3D
var time: float

func _ready() -> void:
	super()
	body = $fleshmound
	time += randf()

func _process(delta: float) -> void:
	time += delta
	var scale_factor = Vector3(
		1.0 + sin(time * 3) * .1,
		1.0 + sin(.33 + time * 3) * .05,
		1.0 + sin(.66 + time * 3) * .1)
	body.scale = scale_factor

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if (player != null):
		direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		var target_pos = player.global_position
		var my_pos = body.global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		body.global_rotation.y = angle
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
		velocity = target_velocity
		
		move_and_slide()
