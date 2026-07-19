extends Node2D

func _ready() -> void:
	$ExplosionFX.emitting = true

func _on_explosion_fx_finished() -> void:
	queue_free()
