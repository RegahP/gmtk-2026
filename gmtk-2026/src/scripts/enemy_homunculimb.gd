extends EnemyBase

var legs: Node3D
var time: float

func _ready() -> void:
	super()
	legs = $homunculimb/Cylinder_002
	time += randf()

func _process(delta: float) -> void:
	time += delta

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if (player != null):
		direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		var target_pos = player.global_position
		var my_pos = global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		global_rotation.y = angle
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
		velocity = target_velocity
		
		legs.rotation.y = sin(time * 6) *.5
		
		move_and_slide()
