extends Node3D

@export var countDownTime: int
@onready var timerLabel: Label = $CountdownUI/Label
@onready var timerUi: Timer = $CountdownUI/Timer
@onready var deathscreenUi: Panel = $DeathscreenUI/Panel

@onready var nextroomUi: Panel = $NextRoomUI/Panel
@onready var clearroomUi: Panel = $NextRoomUI/Panel2
@onready var nextRoomTypeUi: Array[AnimatedSprite2D] = [
	$NextRoomUI/Panel/hostile,
	$NextRoomUI/Panel/pedestal,
	$NextRoomUI/Panel/boss,
	$NextRoomUI/Panel/machine]

var roomCount: int
@export var roomIdsByCount: Array[Vector2i] = []

@export var roomBases: Array[PackedScene]
@export var machineRoom: PackedScene
@export var enemySets: Array[PackedScene]
@export var pedestal: PackedScene
@export var player: Node3D

var currRoomBase: Node3D
var currEnemySet: Node3D
var currPedestal: Node3D

func _ready() -> void:
	player = %player
	print(player)
	
	_loadroom(-1)
	
	timerUi.wait_time = countDownTime + 1
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

func _timer_reduce(damage: float):
	timerUi.start(timerUi.time_left - damage)
	timerLabel.modulate = Color.RED
	await get_tree().create_timer(.1).timeout
	timerLabel.modulate = Color.WHITE

func _on_timer_timeout() -> void:
	timerLabel.text = "00:00"
	print("dead")
	deathscreenUi.visible = true

func _loadroom(nextRoomId: int) -> void:
	_reset_player_pos()
	_clear_room()
	
	if (nextRoomId == -2): # invalid room
		_add_machineroom()
		#print("machine room")
	
	if (nextRoomId == -1): # init room
		print("init room")
	
	if (nextRoomId == 0): # hostile room
		_add_enemyset()
	
	if (nextRoomId >= -1):
		_add_roombase()
	
	if (nextRoomId == 1): # pedestal room
		_add_pedestal()
		
	if (nextRoomId == 2): # boss room
		print("boss room")
		
	roomCount += 1
	#print("loaded nextroom of id " + str(nextRoomId))
	print("roomCount = " + str(roomCount))

func _clear_room() -> void:
	if currRoomBase != null: currRoomBase.queue_free()
	if currEnemySet != null: currEnemySet.queue_free()
	if currPedestal != null: currPedestal.queue_free()

func _add_roombase() -> void:
	currRoomBase = roomBases[_randi(roomBases.size())].instantiate()

	if (currEnemySet == null):
		currRoomBase.doorPicked.connect(_loadroom)
		currRoomBase.doorEntered.connect(_show_nextroom_panel)
		currRoomBase.doorExited.connect(_hide_nextroom_panel)
	else:
		currRoomBase.doorEntered.connect(_show_clearroom_panel)
		currRoomBase.doorExited.connect(_hide_clearroom_panel)
	print("roomIds = " + str(_get_roomidsbycount()))
	currRoomBase._setdoor_nextroomids(_get_roomidsbycount())
	add_child(currRoomBase)
	#print("added roombase")

func _add_machineroom() -> void:
	currRoomBase = machineRoom.instantiate()
	add_child(currRoomBase)
	#print("added machineroom")

func _add_enemyset() -> void:
	currEnemySet = enemySets[_randi(enemySets.size())].instantiate()
	add_child(currEnemySet)
	currEnemySet._set_enemies(player)
	currEnemySet.enemies_cleared.connect(_on_room_cleared)
	#print("added enemyset")

func _add_pedestal() -> void:
	currPedestal = pedestal.instantiate()
	add_child(currPedestal)
	# currPedestal.loadbioupgrade
	# currPedestal.picked.connect(func that changes player atkctrl's attackdata)
	#print("added pedestal")

func _show_nextroom_panel(nextRoomId: int) -> void:
	print("showing nextroom panel")
	nextroomUi.visible = true
	for ui in nextRoomTypeUi:
		ui.visible = false
	nextRoomTypeUi[nextRoomId].visible = true
	
	if (currEnemySet != null):
		print("room cleared: " + str(currEnemySet.setCount == 0))

func _hide_nextroom_panel() -> void:
	print("hidden nextroom panel")
	nextroomUi.visible = false

func _show_clearroom_panel(nextRoomId: int) -> void:
	clearroomUi.visible = true
	
func _hide_clearroom_panel() -> void:
	clearroomUi.visible = false

func _on_room_cleared() -> void:
	currRoomBase.doorEntered.disconnect(_show_clearroom_panel)
	#currRoomBase.doorExited.disconnect(_hide_clearroom_panel)
	
	currRoomBase.doorPicked.connect(_loadroom)
	currRoomBase.doorEntered.connect(_show_nextroom_panel)
	currRoomBase.doorExited.connect(_hide_nextroom_panel)

func _reset_player_pos() -> void:
	player.global_position = Vector3(-1.2, 0, 0)

func _get_roomidsbycount() -> Vector2i:
	if (roomCount < roomIdsByCount.size()):
		return roomIdsByCount[roomCount]
	return Vector2i(-2, -2)

func _randi(size: int) -> int:
	return randi() % size
