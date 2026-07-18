extends Node
@onready var drums: AudioStreamPlayer = $Drums
@onready var melody_boss: AudioStreamPlayer = $Melody_Boss
@onready var melody_norm: AudioStreamPlayer = $Melody_Norm
@onready var melody_shop: AudioStreamPlayer = $Melody_Shop

var drum_tween: Tween
var melody_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	Events.change_melody.connect(handle_melody)
	Events.do_drums.connect(handle_drums)
	
	drums.volume_db = -60.0
	melody_boss.volume_db = -60.0
	melody_norm.volume_db = -60.0
	melody_shop.volume_db = -60.0

func handle_drums(enable: bool):
	if drum_tween and drum_tween.is_valid():
		drum_tween.kill()
	
	drum_tween = get_tree().create_tween()
	drum_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if enable:
		drum_tween.tween_property(drums, "volume_db", -5, 1.0)
	else:
		drum_tween.tween_property(drums, "volume_db", -60, 1.0)

func handle_melody(type: String):
	print("CHANGING MELODY TO: " + type)
	
	if melody_tween and melody_tween.is_valid():
		melody_tween.kill()
	
	melody_tween = get_tree().create_tween()
	melody_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	melody_tween.set_parallel(true)
	
	if type == "boss":
		melody_tween.tween_property(melody_boss, "volume_db", -5, 1)
		melody_tween.tween_property(melody_norm, "volume_db", -60, 2)
		melody_tween.tween_property(melody_shop, "volume_db", -60, 2)
	elif type == "norm":
		melody_tween.tween_property(melody_boss, "volume_db", -60, 2)
		melody_tween.tween_property(melody_norm, "volume_db", -5, 1)
		melody_tween.tween_property(melody_shop, "volume_db", -60, 2)
	elif type == "shop":
		melody_tween.tween_property(melody_boss, "volume_db", -60, 2)
		melody_tween.tween_property(melody_norm, "volume_db", -60, 2)
		melody_tween.tween_property(melody_shop, "volume_db", -5, 1)
	elif type == "none":
		melody_tween.tween_property(melody_boss, "volume_db", -60, 2)
		melody_tween.tween_property(melody_norm, "volume_db", -60, 2)
		melody_tween.tween_property(melody_shop, "volume_db", -60, 2)
