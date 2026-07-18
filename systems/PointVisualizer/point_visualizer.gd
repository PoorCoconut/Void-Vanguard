extends Node2D
class_name PointVisualizer

@onready var points_label: Label = $Points
@onready var point_anim: AnimationPlayer = $PointAnim
var p : int = 0

func _ready() -> void:
	SoundBank.play_sfx("point", Vector2.ZERO)
	GameManager.points += p
	points_label.text = "+ " + str(p) + "P"
	point_anim.play("show_p")

func _on_point_anim_animation_finished(anim_name: StringName) -> void:
	queue_free()
