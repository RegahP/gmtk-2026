extends Camera3D

@export var follow_target: Node3D
var position_offset = Vector3.ZERO

func _ready() -> void:
	position_offset = global_position - follow_target.global_position

func _physics_process(delta: float) -> void:
	global_position = follow_target.global_position + position_offset
