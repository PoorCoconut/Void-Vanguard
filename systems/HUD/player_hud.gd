extends CanvasLayer

@onready var WhiteBar = %WhiteBar
@onready var BarChaser = %BarChaser
var style 

func _ready():
	style = BarChaser.get_theme_stylebox("fill") as StyleBoxFlat
	Events.player_hp_updated.connect(_on_player_hp_updated)

func _on_player_hp_updated(current_hp: float, max_hp: float):
	WhiteBar.max_value = max_hp
	WhiteBar.value = current_hp
	var tween = create_tween()
	tween.tween_property(BarChaser, "value", WhiteBar.value, 0.5).set_trans(Tween.TRANS_SINE)
	
	#if BarChaser.value < 3:
		#BarChaser.value = 0
