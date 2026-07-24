extends Node3D

@export var countDownTime = 11
@onready var timerLabel: Label = $CountdownUI/Label
@onready var timerUi: Timer = $CountdownUI/Timer
@onready var deathscreenUi: Panel = $DeathscreenUI/Panel

var roomCount: int
@export var roomIdsByCount: Array[Vector2i] = []

@export var roomBases: Array[PackedScene]
@export var enemySets: Array[PackedScene]
@export var pedestal: PackedScene
@export var player: Node3D

var currRoomBase: Node3D
var currEnemySet: Node3D
var currPedestal: Node3D

func _ready() -> void:
	_loadroom(-1)
	
	timerUi.wait_time = countDownTime
	timerUi.start()
	timerUi.timeout.connect(_on_timer_timeout)
	timerUi.timeout.connect(player._on_timer_timeout)

func _process(delta: float) -> void:
	_timer_run()

func _timer_run() -> void:
	var time_left: float = timerUi.time_left
	var minutes: int = int(time_left) / 60
	var seconds: int = int(time_left) % 60
	timerLabel.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	timerLabel.text = "00:00"
	print("dead")
	deathscreenUi.visible = true

func _loadroom(nextRoomId: int) -> void:
	_reset_player_pos()
	_clear_room()
	_add_roombase()
	
	if (nextRoomId == -2): # invalid room
		print("invalid room")
		return
	
	if (nextRoomId == -1): # init room
		print("init room")
	
	if (nextRoomId == 0): # hostile room
		_add_enemyset()
	
	if (nextRoomId == 1): # pedestal room
		_add_pedestal()
		
	if (nextRoomId == 2): # boss room
		print("boss room")
		
	roomCount += 1
	print("loaded nextroom of id " + str(nextRoomId))
	print("roomCount = " + str(roomCount))

func _clear_room() -> void:
	if currRoomBase != null: currRoomBase.queue_free()
	if currEnemySet != null: currEnemySet.queue_free()
	if currPedestal != null: currPedestal.queue_free()

func _add_roombase() -> void:
	currRoomBase = roomBases[_randi(roomBases.size())].instantiate()
	currRoomBase.doorPicked.connect(_loadroom)
	print("roomIds = " + str(_get_roomidsbycount()))
	currRoomBase._setdoor_nextroomids(_get_roomidsbycount())
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

func _get_roomidsbycount() -> Vector2i:
	if (roomCount < roomIdsByCount.size()):
		return roomIdsByCount[roomCount]
	return Vector2i(-2, -2)

func _randi(size: int) -> int:
	return randi() % size
