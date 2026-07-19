extends Node2D
class_name EnemyEntity

@export_category("Scale Settings")
@export var target_scale : Vector2 = Vector2(8,8)
@export var scale_time : float = 120.0
@export var start_scale : Vector2 = Vector2.ZERO

@export_category("Easing")
@export_range(0.1, 5.0, 0.1) var ease_power: float = 2.0

var progress : float = 0.0

@onready var body: AnimatedSprite2D = $Body
@onready var body_2: AnimatedSprite2D = $Body2
@onready var tentacle_1: Sprite2D = $Tentacle1
@onready var tentacle_2: Sprite2D = $Tentacle2
@onready var tentacle_3: Sprite2D = $Tentacle3

var scale_elapsed : float = 0.0
var scale_from : Vector2 = Vector2.ZERO
var is_scaling : bool = false
signal time_done

func _ready() -> void:
	if SettingsManager.ldm:
		body.show()
		body_2.show()
		tentacle_1.hide()
		tentacle_2.hide()
		tentacle_3.hide()
	
	scale = start_scale
	scale_from = start_scale

func _process(delta: float) -> void:
	if GameManager.dispel_bought == 10:
		hide()
		is_scaling = false
	
	if not is_scaling:
		return
	
	scale_elapsed += delta
	var t = clamp(scale_elapsed / scale_time, 0.0, 1.0)
	
	progress = t
	Events.enemy_progress.emit(progress)
	
	var eased_t = pow(t, ease_power)
	scale = scale_from.lerp(target_scale, eased_t)
	
	if t >= 1.0:
		time_done.emit()
		is_scaling = false

func reset_scale(new_start: Vector2 = start_scale):
	scale = new_start
	scale_from = new_start
	scale_elapsed = 0.0
	is_scaling = true

func set_new_target(new_target: Vector2, new_time:float):
	target_scale = new_target
	scale_time = new_time
	scale_from = scale
	scale_elapsed = 0.0
	is_scaling = true
