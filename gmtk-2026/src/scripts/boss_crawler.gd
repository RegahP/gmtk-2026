extends EnemyBase
class_name Crawler

var rand_direction = Vector3.ZERO
var player_direction = Vector3.ZERO
var jump_direction = Vector3.ZERO
var time: float

var body: Node3D

var is_spinning: bool
@onready var spinTimer: Timer = $SpinTimer
@export var spinSpeed: float
var clockwise: bool
var spinCount: int

var is_jumping: bool
@onready var jumpTimer: Timer = $JumpTimer

var fleshbud: PackedScene = load("res://src/enemies/enemy_fleshbud.tscn")
var fleshmound: PackedScene = load("res://src/enemies/enemy_fleshmound.tscn")
signal birthed(enemy: Node3D)

func _ready() -> void:
	super()
	body = $crawler
	time += randf()
	spinTimer.timeout.connect(_calculate_direction)
	spinTimer.start()
	jumpTimer.timeout.connect(_jump_end)

func _process(delta: float) -> void:
	time += delta

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if (is_spinning):
		target_velocity.x = player_direction.x * speed
		target_velocity.z = player_direction.z * speed
		
		var spin = spinSpeed if clockwise else -spinSpeed
		rotate(up_direction, spin * .02)
	if (is_jumping):
		jump_direction = Vector3.UP * (sin(deg_to_rad(time * 90 * 2)) * .5)
		body.position.y = jump_direction.y
	
	if (is_moving):
		_enemy_move()

func _calculate_direction() -> void:
	is_spinning = true
	var random_angle : float = randf_range(0.0, TAU)
	rand_direction = Vector3.FORWARD.rotated(Vector3.UP, random_angle)
	rand_direction = rand_direction.normalized()
	player_direction = global_position.direction_to(player.global_position)
	player_direction = player_direction.normalized()
	clockwise = !clockwise
	spinCount += 1
	if (spinCount > 3):
		spinCount = 0
		spinTimer.stop()
		is_spinning = false
		jumpTimer.start()
		_jump_attack()

func _jump_attack() -> void:
	is_jumping = true
	time = 0
	target_velocity = Vector3.ZERO
	
func _jump_end() -> void:
	is_jumping = false
	attack_controller.attack()
	body.position.y = 0
	spinTimer.start()
	
	var bud: bool = true if randi() % 3 == 0 else false
	var birth: Node3D
	if (bud):
		birth = fleshmound.instantiate()
	else:
		birth = fleshbud.instantiate()
	birth.global_position = global_position
	get_parent().add_child(birth)
	birth.player = player
	birthed.emit(birth)
