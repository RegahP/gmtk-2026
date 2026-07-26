extends Control
@onready var music = $AudioStreamPlayer3D

var targetpos: Vector2
var currpos: Vector2
var transitioning: bool = false

func _ready() -> void:
	music.play()
	
	
func _process(delta: float) -> void:
	position = currpos
	if transitioning:
		
		currpos = currpos.lerp(targetpos, 0.1)
	
	if currpos == targetpos:
		transitioning = false

func _on_start_pressed() -> void:
	print("start")
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_credits_pressed() -> void:
	targetpos = Vector2(0, -900)
	transitioning = true
	
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	targetpos = Vector2(0, 0)
	transitioning = true
	
