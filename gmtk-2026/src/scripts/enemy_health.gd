class_name EnemyHealth  
extends Node

@export var max_health: float
var current_health: float
signal died()
signal took_damage()
@onready var death_audio: AudioStreamPlayer = $"../DeathAudio"

func _ready():
	current_health = max_health
	
func _process(delta: float) -> void:
	if (current_health - delta > 0):
		current_health -= delta
	else:
		current_health = 0
		die() 

func take_damage(damage: DamageInfo): # esta funcion la invoca player para atacar exitosamente a enemy
	if (current_health - damage.amount > 0):
		current_health -= damage.amount
		took_damage.emit()
	else:
		
		current_health = 0
		die() 

func die():
	print("%s died!" % owner.name)
	
	if !death_audio.playing:
		death_audio.reparent(get_parent().get_parent())
		death_audio.play()
		
	died.emit()
	#await death_audio.finished
	owner.queue_free()
