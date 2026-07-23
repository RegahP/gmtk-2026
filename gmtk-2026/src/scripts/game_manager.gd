extends Node3D

@export var roomBases: Array[PackedScene]
@export var enemySets: Array[PackedScene]
@export var pedestal: PackedScene
@export var player: Node3D

var currRoomBase: Node3D
var currEnemySet: Node3D
var currPedestal: Node3D

func _ready() -> void:
	_loadinitroom()

func _loadinitroom() -> void:
	_reset_player_pos()
	_add_roombase()
	print("loaded initroom")

func _loadroom(nextRoomId: int) -> void:
	_reset_player_pos()
	_clear_room()
	_add_roombase()
	
	if (nextRoomId == 0): # hostile room
		_add_enemyset()
	
	if (nextRoomId == 1): # pedestal room
		_add_pedestal()
		
	print("loaded nextroom of id " + str(nextRoomId))

func _clear_room() -> void:
	if currRoomBase != null: currRoomBase.queue_free()
	if currEnemySet != null: currEnemySet.queue_free()
	if currPedestal != null: currPedestal.queue_free()

func _add_roombase() -> void:
	currRoomBase = roomBases[_randi(roomBases.size())].instantiate()
	currRoomBase.doorPicked.connect(_loadroom)
	add_child(currRoomBase)
	print("added roombase")

func _add_enemyset() -> void:
	currEnemySet = enemySets[_randi(enemySets.size())].instantiate()
	add_child(currEnemySet)
	print("added enemyset")

func _add_pedestal() -> void:
	currPedestal = pedestal.instantiate()
	add_child(currPedestal)
	# currPedestal.loadbioupgrade
	print("added pedestal")

func _reset_player_pos() -> void:
	player.global_position = Vector3(-1.2, 0, 0)

func _randi(size: int) -> int:
	return randi() % size
