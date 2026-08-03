extends Control
@onready var music = $AudioStreamPlayer3D

var targetpos: Vector2
var currpos: Vector2
var transitioning: bool = false
@export var skipintro: bool
@onready var skip_intro: Button = $SkipIntro
@onready var skip_label: Label = $SkipIntro/Label10

func _ready() -> void:
	music.play()
	skip_label.visible = skipintro

func _process(delta: float) -> void:
	position = currpos
	if transitioning:
		
		currpos = currpos.lerp(targetpos, 0.1)
	
	if currpos == targetpos:
		transitioning = false

func _on_start_pressed() -> void:
	print("start")
	get_tree().change_scene_to_file("res://src/main.tscn" if skipintro else "res://src/intro.tscn")


func _on_credits_pressed() -> void:
	targetpos = Vector2(0, -900)
	transitioning = true

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	targetpos = Vector2(0, 0)
	transitioning = true

func _on_skipintro_toggle() -> void:
	skipintro = !skipintro
	skip_label.visible = skipintro
