class_name Hitbox
extends Area3D

var current_damage: DamageInfo
var hit_targets := {}
@onready var damage_audio: AudioStreamPlayer = $"../../DamageAudio"


func _on_body_entered(body: Node3D) -> void:
	if body in hit_targets:
		return

	hit_targets[body] = true
	if (body is EnemyBase):
		if (body is Fetiw):
			get_parent().get_parent().get_parent()._timer_reduce(1)
			current_damage.amount *= 3
		body.find_child("Health").take_damage(current_damage)
		damage_audio.play()

func reset():
	hit_targets.clear()
