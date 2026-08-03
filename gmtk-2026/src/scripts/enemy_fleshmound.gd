extends EnemyBase
class_name FleshMound

var body: Node3D
var time: float

var currScale = Vector3.ZERO
var scale_factor = Vector3.ZERO

@onready var birth: Ability = $Birth
var fleshbud: PackedScene = load("res://src/enemies/enemy_fleshbud.tscn")
signal birthed(enemy: Node3D)

func _ready() -> void:
	super()
	body = $fleshmound
	time += randf()
	currScale = body.scale
	birth.casted.connect(_birth)
	attack_controller.attack_attempted.connect(_on_attack)

func _process(delta: float) -> void:
	time += delta
	scale_factor = Vector3(
		currScale.x + sin(time * 3) * .1,
		currScale.y + sin(.33 + time * 3) * .05,
		currScale.z + sin(.66 + time * 3) * .1)
	body.scale = scale_factor

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= enable_range:
		var direction = global_position.direction_to(player.global_position)
		direction = direction.normalized()
		
		var target_pos = player.global_position
		var my_pos = global_position
		
		var angle = atan2(my_pos.x - target_pos.x, my_pos.z - target_pos.z)
		global_rotation.y = angle
		
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
		_enemy_move()
	else:
		target_velocity = Vector3.ZERO

func _birth() -> void:
	var child = fleshbud.instantiate()
	child.global_position = global_position
	get_parent().add_child(child)
	child.player = player
	#attack_audio.play()
	birthed.emit(child)

func _on_attack() -> void:
	birth._windup()
