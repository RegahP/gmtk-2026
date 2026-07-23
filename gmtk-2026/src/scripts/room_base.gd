extends Node3D

@onready var doorLeft: DoorData = $floor/exitdoorleft
@onready var doorRight: DoorData = $floor/exitdoorright

signal doorPicked(nextRoomId: int)

func _ready() -> void:
	doorLeft.picked.connect(_loadroomdoor)
	doorRight.picked.connect(_loadroomdoor)

func _loadroomdoor(nextRoomId: int) -> void:
	doorPicked.emit(nextRoomId)
