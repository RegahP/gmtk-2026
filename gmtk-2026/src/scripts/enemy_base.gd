extends CharacterBody3D
class_name EnemyBase

@onready var health: EnemyHealth = $Health
@onready var attack_controller: EnemyAttackController = $EnemyAttackController
@export var animation: AnimationPlayer

var player: Node3D
var meshes: Array[Node] = []
@export var speed: float
@export var enable_range: float
var is_moving := true
var target_velocity = Vector3.ZERO

signal died()

func _ready() -> void:
	meshes = find_children("*", "MeshInstance3D", true, false)
	health.died.connect(_on_died)
	health.took_damage.connect(_on_take_damage)

func _enemy_move():
	velocity = target_velocity
	move_and_slide()

func _on_take_damage() -> void:
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.WHITE
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	for mesh in meshes:
		mesh.set_surface_override_material(0, mat)
		mesh.set_surface_override_material(1, mat)
		
	await get_tree().create_timer(.1).timeout
	
	for mesh in meshes:
		mesh.set_surface_override_material(0, null)
		mesh.set_surface_override_material(1, null)

func _on_died() -> void:
	died.emit()
	
