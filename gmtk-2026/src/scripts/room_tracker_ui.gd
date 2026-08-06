extends Control
class_name RoomTracker

@onready var container = $HBoxContainer
@export var icons: Array[Node] = []
@export var room_icons: Texture2D
@export var cleared_icons: Texture2D

func _ready() -> void:
	_load_icons()
	container.visible = false

func _update_room_icons(roomCount: int, roomId: int) -> void:
	print("ROOMCOUNT: ", roomCount, " ROOMID: ", roomId)
	
	if roomCount == -1:
		return
	
	if roomCount == 0:
		container.visible = true
		return
	
	if roomCount == 7:
		#icons.remove_at(icons.size() - 1)
		#icons.remove_at(icons.size() - 1)
		container.get_child(container.get_child_count() - 2).visible = false
		container.get_child(container.get_child_count() - 3).visible = false
	
	var icon_room = icons[0].duplicate()
	var icon_next = icons[1].duplicate()
	container.add_child(icon_room)
	container.add_child(icon_next)
	container.move_child(icon_room, 0 + (roomCount - 1) * 2)
	container.move_child(icon_next, 1 + (roomCount - 1) * 2)
	_load_icons()
	
	icon_room.texture = icon_room.texture.duplicate()
	icon_room.texture.atlas = cleared_icons
	icon_room.texture.region.position = Vector2(roomId * 128, 0)

func _load_icons() -> void:
	icons = container.find_children("*", "TextureRect")
