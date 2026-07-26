extends Control

func _ready() -> void:
	$AnimationPlayer.play("endscreen_fade")

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://src/main_menu.tscn")
