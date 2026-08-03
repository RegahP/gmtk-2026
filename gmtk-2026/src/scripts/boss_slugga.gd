extends EnemyBase
class_name Slugga

var is_started: bool
var phase: bool
var clockwise: bool
@onready var attackTimer: Timer = $AttackTimer
@onready var phaseTimer: Timer = $PhaseTimer

@onready var attackAnim: AnimationPlayer = $AnimationPlayer
@onready var attack_audio2: AudioStreamPlayer = $AttackAudio2

func _ready() -> void:
	super()
	await get_tree().create_timer(1).timeout.connect(_start)
	phaseTimer.timeout.connect(_phase_change)
	attackTimer.timeout.connect(_attack_calculate)
	$slugga_tong.visible = false

func _start() -> void:
	is_started = true
	phaseTimer.start()
	attackTimer.start()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if (is_started):
		if phase:
			var spin = 1 if clockwise else -1
			rotate(up_direction, spin * .015)
		else:
			var target_transform = global_transform.looking_at(player.global_position)
			var current_quat = global_transform.basis.get_rotation_quaternion()
			var target_quat = target_transform.basis.get_rotation_quaternion()
			current_quat = current_quat.slerp(target_quat, 1 * delta)
			global_transform.basis = Basis(current_quat)
	
	if (is_moving):
		_enemy_move()

func _phase_change() -> void:
	phase = !phase

func _attack_calculate() -> void:
	if phase:
		$Weapon/Hitbox/CollisionShape3D.disabled = false
		$Weapon/Hitbox/CollisionShape3D2.disabled = false
		$Weapon/Hitbox/CollisionShape3D3.disabled = true
		_spin_change()
		_spike_attack()
	else:
		$Weapon/Hitbox/CollisionShape3D.disabled = true
		$Weapon/Hitbox/CollisionShape3D2.disabled = true
		$Weapon/Hitbox/CollisionShape3D3.disabled = false
		_tong_attack()

func _spin_change() -> void:
	clockwise = !clockwise

func _spike_attack() -> void:
	attackAnim.play("slugga_spikes")
	#_spike_windup()

func _tong_attack() -> void:
	attackAnim.play("slugga_tong")
	$slugga_tong.visible = true
	#_attack_windup()

#func _spike_windup() -> void:
	##print("ATTACKING PLAYER")
	#is_moving = false
	#await get_tree().create_timer(attack_windup).timeout
	#var distance = global_position.distance_to(player.global_position)
	#if distance <= attack_range:
		#if !attack_audio2.playing: attack_audio2.play()
		#_attack_player(true)
	#else:
		#is_moving = true
