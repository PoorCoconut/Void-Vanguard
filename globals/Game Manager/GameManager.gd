extends Node

var CURRENT_WORLD_STATE : String = "Nothing"
const SAVE_PATH : String = "user://savegame.json"
var ldm : bool = false
var touch_screen : bool = false

var points : int = 0
var difficulty : String = "e"
var diff_dmg : int = 0
var diff_speed : float = 0
var diff_hp : int = 0
var diff_points_mult : int = 1

#Player Upgrades
var hull_upgraded: int = 0
var thruster_upgraded: int = 0
var laser_upgraded : int = 0
var dispel_bought : int = 0

var hull_health : int = 0
var thruster_speed : float = 0
var thruster_turn : float = 0
var laser_cooldown : float = 0
var laser_damage : int = 0
var laser_speed : int = 0


func _ready() -> void:
	print("GAME MANAGER LOADED!")

func reset_game():
	hull_upgraded = 0
	thruster_upgraded = 0
	laser_upgraded = 0
	dispel_bought = 0
	hull_health = 0
	thruster_speed = 0
	thruster_turn = 0
	laser_cooldown = 0
	laser_damage = 0
	
	points = 0
	difficulty = "e"
	diff_dmg = 0
	diff_speed = 0
	diff_hp = 0
	diff_points_mult = 1
##SAVE FILE LOGIC
func save_player_position(player_pos: Vector2) -> void:
	var save_data = {
		"player_x": player_pos.x,
		"player_y": player_pos.y
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	print("Game Saved!")

func load_player_position():
	#Check if the player has ever saved the game before
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found. Starting from the bottom!")
		return null # Returning null lets the Player node know to use its default spawn
		
	#Open the file and read the text
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_text = file.get_as_text()
	
	#Parse the JSON back into a dictionary
	var save_data = JSON.parse_string(json_text)
	
	#Extract the coordinates and return them as a usable Vector2
	if save_data and save_data.has("player_x") and save_data.has("player_y"):
		var loaded_pos = Vector2(save_data["player_x"], save_data["player_y"])
		print("Save loaded! Teleporting player to: ", loaded_pos)
		return loaded_pos
	return null

##Next Level Helper Functions
func load_next_level(next_level_path : String) -> void:
	await ScreenTransition.trans_in().finished
	LoadingScreen.load_level(next_level_path)

##Camera Helper Functions
func do_camera_shake(intensity:float, time:float):
	if get_tree().get_first_node_in_group("camera"):
		var camera = get_tree().get_first_node_in_group("camera")
		var camera_tween = get_tree().create_tween()
		camera_tween.tween_method(camera.startCameraShake, intensity, 1.0, time)
		camera.startCameraShake(intensity)
		await get_tree().create_timer(time).timeout
		camera.resetCameraOffset()

func move_camera_to_player(player_pos : Vector2):
	if get_tree().get_first_node_in_group("camera"):
		var camera = get_tree().get_first_node_in_group("camera")
		camera.moveCameraToEntity(player_pos)
