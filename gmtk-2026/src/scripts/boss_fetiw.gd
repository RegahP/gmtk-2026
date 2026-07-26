extends EnemyBase
class_name Fetiw

func _ready() -> void:
	super()

func _on_take_damage() -> void:
	super()
	if !attack_audio.playing:
		attack_audio.play()
