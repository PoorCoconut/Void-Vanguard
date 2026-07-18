extends Node2D
class_name fxGreenExplosion

@onready var light: CPUParticles2D = $light
@onready var dark: CPUParticles2D = $dark

func _ready() -> void:
	light.emitting = true
	dark.emitting = true
	await get_tree().create_timer(0.7).timeout
	queue_free()
