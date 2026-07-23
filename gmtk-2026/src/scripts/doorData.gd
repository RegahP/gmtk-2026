extends Node3D
class_name DoorData

@export var localDoorId: int
@export var nextRoomId: int
var playerInside: bool

signal entered(localDoorId: int)
signal exited(localDoorId: int)
signal picked(nextRoomId: int)

func _ready() -> void:
	$Area3D.body_entered.connect(_on_door_entered)
	$Area3D.body_exited.connect(_on_door_exited)
	
func _process(delta: float) -> void:
	if playerInside:
		if Input.is_action_pressed("interact"):
			print("door picked")
			picked.emit(nextRoomId)
			playerInside = false

func _on_door_entered(body: Node3D) -> void:
	if (body.name == "player"):
		print("door entered")
		playerInside = true
		entered.emit(localDoorId)
	
func _on_door_exited(body: Node3D) -> void:
	if (body.name == "player"):
		print("door exited")
		playerInside = false
		exited.emit(localDoorId)
