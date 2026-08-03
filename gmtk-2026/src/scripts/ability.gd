extends Node3D
class_name Ability

@export var data: AbilityData
@onready var audio: AudioStreamPlayer = $AbilityAudio

var is_casting: bool

signal started()
signal casted()
signal ended()

func _windup() -> bool:
	if (!is_casting):
		_play_sound(data.sound)
		is_casting = true
		started.emit()
		get_tree().create_timer(data.windup).timeout.connect(_cast)
		return true
	return false

func _cast() -> void:
	casted.emit()
	await get_tree().create_timer(data.cooldown).timeout
	is_casting = false
	ended.emit()

func _play_sound(stream: AudioStreamMP3) -> void:
	audio.stream = stream
	audio.play()
