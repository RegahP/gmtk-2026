extends VideoStreamPlayer

func _on_finished() -> void:
	get_tree().change_scene_to_file("res://src/main.tscn")

func _on_skip_timer_timeout() -> void:
	$Control/Button.disabled = false
	$Control/Button.visible = true

func _on_button_pressed() -> void:
	_on_finished()
