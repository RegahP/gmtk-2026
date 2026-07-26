extends Node3D
class_name Pedestal

var used: bool = false
var playerInside: bool

signal entered()
signal exited()
signal picked()

func _ready() -> void:
	$mesh/Area3D.body_entered.connect(_on_pedestal_entered)
	$mesh/Area3D.body_exited.connect(_on_pedestal_exited)
	
func _process(delta: float) -> void:
	if !used:
		if playerInside:
			if Input.is_action_pressed("interact"):
				print("pedestal picked")
				picked.emit()
				playerInside = false
				used = true
				$item.visible = false

func _on_pedestal_entered(body: Node3D) -> void:
	if !used:
		if (body.name == "player"):
			print("pedestal entered")
			playerInside = true
			entered.emit()
	
func _on_pedestal_exited(body: Node3D) -> void:
	if !used:
		if (body.name == "player"):
			print("pedestal exited")
			playerInside = false
			exited.emit()
