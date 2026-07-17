extends Node2D

@onready var explode_dark: CPUParticles2D = $ExplodeDark
@onready var explode_med: CPUParticles2D = $ExplodeMed
@onready var explode_light: CPUParticles2D = $ExplodeLight
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	SoundBank.play_sfx("long_explosion", global_position)
	explode_dark.emitting = true
	explode_med.emitting = true
	explode_light.emitting = true

func _on_explode_dark_finished() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	hitbox_component.queue_free()
	pass # Replace with function body.
