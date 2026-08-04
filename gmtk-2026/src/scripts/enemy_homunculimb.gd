extends EnemyBase

var legs: Node3D
var time: float
@export var leap_range: float
@export var can_leap := true
@export var is_leaping := false
@export var leap_cooldown: float
@export var leap_target: Vector3
@export var leap_origin: Vector3

func _ready() -> void:
	super()
	legs = $homunculimb/Cylinder_003
	time += randf()

func _process(delta: float) -> void:
	time += delta

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= leap_range:
		if (!is_leaping && can_leap):
			_attack_leap()
	
	#if distance <= attack_range:
	#	if (is_moving || is_moving && is_leaping):
	#		_attack_windup()
		
	legs.rotation.y = 90 + sin(time * 6) *.5
	
	if is_leaping:
		await get_tree().create_timer(.3).timeout
		var direction = leap_origin.direction_to(leap_target)
		direction = direction.normalized()
	
		var target_pos = player.global_position
		var my_pos = global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		global_rotation.y = angle
	
		target_velocity.x = direction.x * speed * 5
		target_velocity.z = direction.z * speed * 5
		
		_enemy_move()
	
	if is_moving && distance <= enable_range:
		var dist = global_position.distance_to(player.global_position)
		if dist > 2: return
		var direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		
		var target_pos = player.global_position
		var my_pos = global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		global_rotation.y = angle
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
		
		_enemy_move()
		
	if !is_moving && !is_leaping:
		target_velocity = Vector3.ZERO

func _attack_leap() -> void:
	can_leap = false
	is_leaping = true
	is_moving = false
	await get_tree().create_timer(.3).timeout
	leap_target = player.global_position + player.target_velocity.normalized() * .25
	leap_origin = global_position
	await get_tree().create_timer(leap_cooldown).timeout
	is_leaping = false
	is_moving = true
	target_velocity = Vector3.ZERO
	await get_tree().create_timer(leap_cooldown).timeout
	can_leap = true
