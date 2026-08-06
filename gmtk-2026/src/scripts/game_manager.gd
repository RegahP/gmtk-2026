extends Node3D

@export var countDownTime: int
@onready var timerLabel: Label = $CountdownUI/Label
@onready var timerUi: Timer = $CountdownUI/Timer
@onready var deathscreenUi: Panel = $DeathscreenUI/Panel
@onready var deathTimer: Timer = $DeathscreenUI/DeathTimer

@onready var nextroomUi: Panel = $NextRoomUI/Panel
@onready var clearroomUi: Panel = $NextRoomUI/Panel2
@onready var clearpedestalUi: Panel = $NextRoomUI/Panel3
@onready var nextRoomTypeUi: Array[AnimatedSprite2D] = [
	$NextRoomUI/Panel/hostile,
	$NextRoomUI/Panel/pedestal,
	$NextRoomUI/Panel/boss,
	$NextRoomUI/Panel/machine]

var roomCount: int
var lastRoomId: int = 0
@export var roomIdsByCount: Array[Vector2i] = []

@export var roomBases: Array[PackedScene]
@export var machineRoom: PackedScene
@export var machineEnemies: PackedScene
@export var enemySets: Array[PackedScene]
@export var bossSets: Array[PackedScene]
@export var pedestal: PackedScene
@export var player: Node3D

var enemySetIds: Array[int] = []
var bossSetIds: Array[int] = []

var currRoomBase: Node3D
var currEnemySet: Node3D
var currPedestal: Node3D

var weapon_evolve_lvl: int
@export var weaponEvoAttackDatas: Array[AttackData] = []

@onready var barUi: AnimatedSprite2D = $HeartUI/Panel/heart/bar
@onready var heartUi: AnimatedSprite2D = $HeartUI/Panel/heart/heart
@onready var weaponEvoUi: Panel = $WeaponUI/Panel
@onready var weaponEvo: AnimatedSprite2D = $WeaponUI/Panel/weapon2
@onready var currWeapon: AnimatedSprite2D = $WeaponUI/weapon/weapon

@onready var roomTracker: RoomTracker = $RoomTrackerUI

@onready var music = $AudioStreamPlayer3D

func _ready() -> void:
	player = %player
	print(player)
	heartUi.play("heart")
	_loadroom(-1)
	
	timerUi.wait_time = countDownTime + 1
	timerUi.start()
	timerUi.timeout.connect(_on_timer_timeout)
	timerUi.timeout.connect(player._on_timer_timeout)

func _process(_float) -> void:
	_timer_run()

func _timer_run() -> void:
	_calculate_heartbar()
	var time_left: float = timerUi.time_left
	var minutes: int = int(time_left) / 60
	var seconds: int = int(time_left) % 60
	timerLabel.text = "%02d:%02d" % [minutes, seconds]

func _timer_reduce(damage: float):
	_calculate_heartbar()
	timerUi.start(timerUi.time_left - damage)
	if damage > 0:
		timerLabel.modulate = Color.RED
	else:
		timerLabel.modulate = Color.GREEN
	await get_tree().create_timer(.1).timeout
	timerLabel.modulate = Color.WHITE

func _recover_time() -> void:
	_timer_reduce(-5)

func _calculate_heartbar() -> void:
	var barSpriteId = clamp(floori((1 - timerUi.time_left / 180) * 12), 0, 12 - 1)
	barUi.frame = barSpriteId
	if timerUi.time_left < 180 / 2: heartUi.play("heart2")

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://src/deathscreen.tscn")
	timerLabel.text = "00:00"
	print("dead")
	deathscreenUi.visible = true
	deathTimer.start()

func _loadroom(nextRoomId: int) -> void:
	_reset_player_pos()
	_clear_room()
	#nextRoomId = 3
	if (nextRoomId in [-1, 0, 1, 2]):
		_add_roombase()
		
	if (nextRoomId == -1): # init room
		print("init room")
	
	if (nextRoomId == 0): # hostile room
		_add_enemyset()
	
	if (nextRoomId == 1): # pedestal room
		_add_pedestal()
	
	if (nextRoomId == 2): # boss room
		_add_bossset()
		
	if (nextRoomId == 3): # machine room
		_add_machineroom()
		#print("machine room")
	
	roomTracker._update_room_icons(roomCount - 1, lastRoomId)
	lastRoomId = nextRoomId
	
	roomCount += 1
	#print("loaded nextroom of id " + str(nextRoomId))
	print("roomCount = " + str(roomCount))

func _clear_room() -> void:
	if currRoomBase != null: currRoomBase.queue_free()
	if currEnemySet != null: currEnemySet.queue_free()
	if currPedestal != null: currPedestal.queue_free()

func _add_roombase() -> void:
	currRoomBase = roomBases[_randi(roomBases.size())].instantiate()
	currRoomBase._doors_unlock()
	currRoomBase.doorPicked.connect(_loadroom)
	currRoomBase.doorEntered.connect(_show_nextroom_panel)
	currRoomBase.doorExited.connect(_hide_panels)
	currRoomBase.doorLocked.connect(_show_locked_panel)
	print("roomIds = " + str(_get_roomidsbycount()))
	currRoomBase._setdoor_nextroomids(_get_roomidsbycount())
	add_child(currRoomBase)
	#print("added roombase")

func _add_machineroom() -> void:
	currRoomBase = machineRoom.instantiate()
	add_child(currRoomBase)
	
	currEnemySet = machineEnemies.instantiate()
	add_child(currEnemySet)
	currEnemySet._set_enemies(player)
	currEnemySet.enemies_cleared.connect(_enddoor)
	$Camera3D/MeshInstance3D2.visible = true
	music.stream = load("res://src/Music/cirno.mp3")
	music.play()

func _add_enemyset() -> void:
	if enemySetIds.size() == enemySets.size(): enemySetIds.clear()
	var setId = _randi(enemySets.size())
	while(enemySetIds.has(setId)):
		setId = _randi(enemySets.size())
	enemySetIds.append(setId)
	currRoomBase._doors_lock()
	currEnemySet = enemySets[setId].instantiate()
	add_child(currEnemySet)
	currEnemySet._set_enemies(player)
	currEnemySet.enemies_cleared.connect(currRoomBase._doors_unlock)
	currEnemySet.enemies_cleared.connect(_recover_time)

func _add_bossset() -> void:
	if bossSetIds.size() == bossSets.size(): bossSetIds.clear()
	var setId = _randi(bossSets.size())
	while(bossSetIds.has(setId)):
		setId = _randi(bossSets.size())
	bossSetIds.append(setId)
	currRoomBase._doors_lock()
	currEnemySet = bossSets[setId].instantiate()
	add_child(currEnemySet)
	currEnemySet._set_enemies(player)
	currEnemySet.enemies_cleared.connect(_add_pedestal)

func _add_pedestal() -> void:
	currEnemySet = null
	currPedestal = pedestal.instantiate()
	add_child(currPedestal)
	currRoomBase._doors_lock()
	currPedestal.entered.connect(_show_weaponevo_panel)
	currPedestal.exited.connect(_hide_weaponevo_panel)
	currPedestal.picked.connect(_hide_weaponevo_panel)
	currPedestal.picked.connect(currRoomBase._doors_unlock)
	currPedestal.picked.connect(_weapon_evolve)

func _enddoor() -> void:
	currRoomBase.doorPicked.connect(_end)
	currRoomBase._set_enddoor()

func _end() -> void:
	get_tree().change_scene_to_file("res://src/main_menu.tscn")

func _show_nextroom_panel(nextRoomId: int) -> void:
	#print("showing nextroom panel")
	nextroomUi.visible = true
	for ui in nextRoomTypeUi:
		ui.visible = false
	nextRoomTypeUi[nextRoomId].visible = true
	
	if (currEnemySet != null):
		print("room cleared: " + str(currEnemySet.setCount == 0))

func _hide_panels() -> void:
	#print("hidden nextroom panel")
	nextroomUi.visible = false
	clearroomUi.visible = false
	clearpedestalUi.visible = false

func _show_locked_panel() -> void:
	if (currEnemySet != null && currEnemySet.setCount != 0):
		clearroomUi.visible = true
	elif (currPedestal != null && !currPedestal.used):
		clearpedestalUi.visible = true

func _show_weaponevo_panel() -> void:
	weaponEvoUi.visible = true
	
func _hide_weaponevo_panel() -> void:
	weaponEvoUi.visible = false
	
func _weapon_evolve() -> void:
	weapon_evolve_lvl += 1
	currWeapon.frame = weapon_evolve_lvl
	weaponEvo.frame = weapon_evolve_lvl + 1
	if (weapon_evolve_lvl < weaponEvoAttackDatas.size()):
		player._weapon_evolve(weaponEvoAttackDatas[weapon_evolve_lvl])

func _reset_player_pos() -> void:
	player.global_position = Vector3(-1.2, 0, 0)

func _get_roomidsbycount() -> Vector2i:
	if (roomCount < roomIdsByCount.size()):
		return roomIdsByCount[roomCount]
	return Vector2i(-2, -2)

func _randi(size: int) -> int:
	return randi() % size
