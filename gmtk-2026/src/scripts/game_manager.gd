extends Node3D

@export var roomBases: Array[PackedScene]
@export var enemySets: Array[PackedScene]
@export var pedestal: PackedScene

var currRoomBase: Node3D
var currEnemySet: Node3D

func _ready() -> void:
	_loadinitroom()

func _loadinitroom() -> void:
	currRoomBase = roomBases[_randi(roomBases.size())].instantiate()
	currRoomBase.doorPicked.connect(_loadroom)
	add_child(currRoomBase)
	print("loading initroom")

func _loadroom(nextRoomId: int) -> void:
	if currRoomBase != null: currRoomBase.queue_free()
	if currEnemySet != null: currEnemySet.queue_free()
	currRoomBase = roomBases[_randi(roomBases.size())].instantiate()
	currRoomBase.doorPicked.connect(_loadroom)
	currEnemySet = enemySets[_randi(enemySets.size())].instantiate()
	add_child(currRoomBase)
	add_child(currEnemySet)
	print("loading nextroom of id " + str(nextRoomId))

func _randi(size: int) -> int:
	return randi() % size
