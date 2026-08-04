class_name EnemyAttackController
extends Node3D

@onready var audio: AudioStreamPlayer = $AttackAudio
var animation: AnimationPlayer

@export var attacks: Array[Node] = []
@export var currAttack: Attack
@export var is_attacking: bool

signal attack_attempted()
signal attack_landed()
signal attack_missed()
signal attack_ended()

func _ready() -> void:
	attacks = find_children("*", "Attack", false)
	
	for attack in attacks:
		if (attack._is_passive()):
			currAttack = attack
			attack.autocasted.connect(func(): _attack(attacks.find(attack)))
		attack.attempted.connect(_on_attempted)
		attack.landed.connect(_on_landed)
		attack.missed.connect(_on_missed)
		attack.ended.connect(_on_ended)

func _attack(atkId: int) -> void:
	if (!is_attacking):
		if (attacks[atkId]._windup()):
			is_attacking = true
			currAttack = attacks[atkId]
			if (!currAttack.data.animation_name.is_empty()):
				animation.play(attacks[atkId].data.animation_name)

func _get_attack(atkId: int) -> Attack:
	return attacks[atkId]

func _play_sound(stream: AudioStreamMP3) -> void:
	audio.stream = stream
	audio.play()

func _on_attempted() -> void:
	_play_sound(currAttack.data.sound)
	attack_attempted.emit()

func _on_landed() -> void:
	attack_landed.emit()

func _on_missed() -> void:
	attack_missed.emit()

func _on_ended() -> void:
	is_attacking = false
	attack_ended.emit()

func _is_attacking() -> bool:
	return is_attacking
