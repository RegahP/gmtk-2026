extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://src/credits_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
