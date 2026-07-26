extends Control
@onready var music = $AudioStreamPlayer3D

func _ready() -> void:
	music.play()

func _on_start_pressed() -> void:
	print("start")
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://src/credits_menu.tscn")
	print("credits")

func _on_exit_pressed() -> void:
	get_tree().quit()
