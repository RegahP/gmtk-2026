extends Node3D
class_name Pedestal

@export var bioUpgrade: int
var used: bool = false

var playerInside: bool

signal entered(bioUpgrade: int)
signal exited(bioUpgrade: int)
signal picked(bioUpgrade: int)

func _ready() -> void:
	$mesh/Area3D.body_entered.connect(_on_pedestal_entered)
	$mesh/Area3D.body_exited.connect(_on_pedestal_exited)
	
func _process(delta: float) -> void:
	if !used:
		if playerInside:
			if Input.is_action_pressed("interact"):
				print("pedestal picked")
				picked.emit(bioUpgrade)
				playerInside = false
				used = true
				$item.visible = false

func _on_pedestal_entered(body: Node3D) -> void:
	if !used:
		if (body.name == "player"):
			print("door entered")
			playerInside = true
			entered.emit(bioUpgrade)
	
func _on_pedestal_exited(body: Node3D) -> void:
	if !used:
		if (body.name == "player"):
			print("door exited")
			playerInside = false
			exited.emit(bioUpgrade)
