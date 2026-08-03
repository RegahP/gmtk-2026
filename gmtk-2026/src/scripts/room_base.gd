extends Node3D

@export var doors: Array[DoorData]

signal doorPicked(nextRoomId: int)
signal doorEntered(nextRoomId: int)
signal doorExited()
signal doorLocked()

func _ready() -> void:
	for door in doors:
		if door.nextRoomId != 4:
			
			door.picked.connect(_on_door_picked)
			door.entered.connect(_on_door_entered)
			door.exited.connect(_on_door_exited)
			door.locked.connect(_on_door_locked)
		else:
			door.picked.connect(_on_door_picked)

func _set_enddoor() -> void:
	for door in doors:
		door._set_enddoor()

func _on_door_picked(nextRoomId: int) -> void:
	doorPicked.emit(nextRoomId)

func _on_door_entered(nextRoomId: int) -> void:
	doorEntered.emit(nextRoomId)

func _on_door_exited() -> void:
	doorExited.emit()

func _on_door_locked() -> void:
	doorLocked.emit()

func _doors_lock() -> void:
	for door in doors:
		door.is_locked = true
	
func _doors_unlock() -> void:
	for door in doors:
		door.is_locked = false

func _setdoor_nextroomids(roomIds: Vector2i) -> void:
	if (roomIds.y != -1):
		doors[0]._set_nextroomid(roomIds.x)
		doors[1]._set_nextroomid(roomIds.y)
		doors[2].queue_free()
		doors.remove_at(2)
	else:
		doors[0].queue_free()
		doors[1].queue_free()
		doors.remove_at(0)
		doors.remove_at(0)
		doors[0].visible = true
		doors[0]._set_nextroomid(roomIds.x)
