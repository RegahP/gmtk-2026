extends Node3D
class_name DoorData

@export var localDoorId: int
@export var nextRoomId: int
var playerInside: bool

signal entered(localDoorId: int)
signal exited(localDoorId: int)
signal picked(nextRoomId: int)

func _ready() -> void:
	if !visible:
		queue_free()
	$Area3D.body_entered.connect(_on_door_entered)
	$Area3D.body_exited.connect(_on_door_exited)
	
func _process(delta: float) -> void:
	if playerInside:
		if Input.is_action_just_pressed("interact"):
			print("door picked")
			print("_______________________")
			playerInside = false
			picked.emit(nextRoomId)

func _on_door_entered(body: Node3D) -> void:
	if (body.name == "player"):
		# print("door entered")
		playerInside = true
		entered.emit(localDoorId)
	
func _on_door_exited(body: Node3D) -> void:
	if (body.name == "player"):
		# print("door exited")
		playerInside = false
		exited.emit(localDoorId)

func _set_nextroomid(roomId: int) -> void:
	nextRoomId = roomId
