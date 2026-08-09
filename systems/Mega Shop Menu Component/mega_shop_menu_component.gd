extends CanvasLayer
class_name SectorShopMenuComponent

@onready var sector_points: Label = %SectorPoints
@onready var ss_message: Label = %SSMessage

@export var message_dur : float = 1

var shop_messages : Array = [
	"Welcome to the station!  Find anything interesting?",
	"Anything to upgrade on this fine galactic evening?",
	"Weapons primed - Modules checked - Upgrades delivered!",
	"Our deals are already discounted just for you! Save the Universe!",
	"The Void Vanguard docks into the sector shop!",
	"They say if you look at the galaxy's stars you'll find a secret path!",
	"Have you been to Apocrypha?",
	"Save the worlds, Void Vanguard!",
	
	]

func _ready() -> void:
	ss_message.visible_ratio = 0
	ss_message.text = shop_messages[randi_range(0, shop_messages.size()-1)]
	show_shop()

func show_shop():
	Events.change_melody.emit("shop")
	var tween = get_tree().create_tween()
	tween.tween_property(ss_message, "visible_ratio", 1.0, message_dur)

func hide_shop():
	pass
