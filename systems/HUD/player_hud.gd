extends CanvasLayer
@onready var main_hp_bar = %WhiteBar
@onready var chaser_bar = %BarChaser
var style 
var hp_tween: Tween
@export var chase_speed: float = 3.0 # hp units per second
@export var min_duration: float = 0.15 # floor so even 1hp chips are visible

func _ready():
	Events.player_hp_updated.connect(_on_player_hp_updated)

func _on_player_hp_updated(current_hp: float, max_hp: float):
	main_hp_bar.max_value = max_hp
	chaser_bar.max_value = max_hp
	main_hp_bar.value = current_hp
	
	if hp_tween and hp_tween.is_valid():
		hp_tween.kill()
	
	var distance = abs(chaser_bar.value - current_hp)
	var duration = max(distance / chase_speed, min_duration)
	
	hp_tween = create_tween()
	hp_tween.tween_property(chaser_bar, "value", current_hp, duration).set_trans(Tween.TRANS_SINE)
