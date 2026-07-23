extends Node3D

@export var doors: Array[DoorData]

signal doorPicked(nextRoomId: int)

func _ready() -> void:
	for door in doors:
		door.picked.connect(_loadroomdoor)

func _loadroomdoor(nextRoomId: int) -> void:
	doorPicked.emit(nextRoomId)

func _setdoor_nextroomids(roomIds: Vector2i) -> void:
	if (roomIds.y != -1):
		doors[0]._set_nextroomid(roomIds.x)
		doors[1]._set_nextroomid(roomIds.y)
	else:
		doors[0].visible = false
		doors[1].visible = false
		doors[2].visible = true
		doors[2]._set_nextroomid(roomIds.x)
