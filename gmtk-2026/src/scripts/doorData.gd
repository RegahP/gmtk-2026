extends Node3D
class_name DoorData

@export var localDoorId: int
@export var nextRoomId: int
var playerInside: bool

signal picked(nextRoomId: int)
signal entered(nextRoomId: int)
signal exited()
signal locked()
var is_locked: bool

func _ready() -> void:
	if nextRoomId != 4:
		$Area3D.body_entered.connect(_on_door_entered)
		$Area3D.body_exited.connect(_on_door_exited)

func _set_enddoor() -> void:
	$Area3D.body_entered.connect(_on_door_entered)
	$Area3D.body_exited.connect(_on_door_exited)
	picked.connect(_end)
func _end(nextRoomId: int) -> void:
	get_tree().change_scene_to_file("res://src/main_menu.tscn")
	
func _process(delta: float) -> void:
	if playerInside && !is_locked:
		if Input.is_action_just_pressed("interact"):
			print("door picked")
			print("_______________________")
			playerInside = false
			picked.emit(nextRoomId)

func _on_door_entered(body: Node3D) -> void:
	if (body.name == "player"):
		# print("door entered")
		if is_locked:
			locked.emit()
			return
		playerInside = true
		entered.emit(nextRoomId)
		$doorclosed.visible = false
		$dooropened.visible = true
	
func _on_door_exited(body: Node3D) -> void:
	if (body.name == "player"):
		# print("door exited")
		playerInside = false
		exited.emit()
		$doorclosed.visible = true
		$dooropened.visible = false

func _set_nextroomid(roomId: int) -> void:
	nextRoomId = roomId
