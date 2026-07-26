extends EnemyBase
class_name FleshMound

var body: Node3D
var time: float

var fleshbud: PackedScene = load("res://src/enemies/enemy_fleshbud.tscn")
signal birthed(enemy: Node3D)

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
		var my_pos = body.global_position
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		body.global_rotation.y = angle
		attack_controller.weapon.rotation.y = angle
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
		_enemy_move()
	else:
		target_velocity = Vector3.ZERO

func _attack_windup() -> void:
	super()
	var fleshbud = fleshbud.instantiate()
	fleshbud.global_position = global_position
	get_parent().add_child(fleshbud)
	fleshbud.player = player
	birthed.emit(fleshbud)
