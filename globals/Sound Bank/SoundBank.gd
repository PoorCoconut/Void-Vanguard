extends Node

#Store sound effects here...
var sfx_dict : Dictionary = {
	"ui_buy" : preload("uid://cfjheddeeen0d"),
	"countdown" : preload("uid://bllghm36glfuh"),
	"dispell" : preload("uid://ddiuor0ftkqk4"),
	"enemy_explode" : preload("uid://d3r00te3cnntf"),
	"enemy_hit" : preload("uid://bbt28awbbs65a"),
	"explode1" : preload("uid://vxnf8xdra3vn"),
	"explode2" : preload("uid://csk7b5xx2wx3o"),
	"game_over" : preload("uid://bk4gkpqvfx4sk"),
	"long_explosion" : preload("uid://ng0j72ibydhp"),
	"player_death" : preload("uid://bxhdto7n1tsci"),
	"player_hit" : preload("uid://b8hnn0lsij1n2"),
	"point" : preload("uid://i5je5mq4261"),
	"shoot" : preload("uid://c77pwimp5wch8"),
	"ui_back" : preload("uid://kwjnfnxf5150"),
	"ui_next" : preload("uid://bw1ws6jbp3ml7"),
	"ui_next2" : preload("uid://3hvrjk0cqlo4")
}

#Here is an example:
#"swing_sword": preload("res://audio/sfx/swing.ogg"),
#"jump": preload("res://audio/sfx/jump.ogg"),
#"slide_friction": preload("res://audio/sfx/friction.wav")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_sfx(sfx_name : String, spawn_pos : Vector2) -> void:
	#Check if sound exists
	if not sfx_dict.has(sfx_name):
		push_error("GameManager: SFX '" + sfx_name + "' not found in dictionary.")
		return
		
	#Create an audio player
	var sfx_player = AudioStreamPlayer2D.new()
	
	#Give it the specific sound from the dictionary and set its position
	sfx_player.stream = sfx_dict[sfx_name]
	sfx_player.global_position = spawn_pos
	sfx_player.pitch_scale = randf_range(0.7, 1.2) #Change these values for more variation of the sounds
	sfx_player.bus = "SFX"
	
	#Add it to the GameManager, play it, and queue_free when done
	add_child(sfx_player)
	sfx_player.finished.connect(sfx_player.queue_free)
	sfx_player.play()
