extends Node2D
@export_file("*.tscn") var next_level_path: String
@export_file("*.tscn") var win_path: String
@export var no_wave : bool = false
@onready var count_down: AnimationPlayer = $CountDown
@onready var wave_manager: WaveManager = $WaveManager
@onready var shop: ShopMenuComponent = $ShopMenuComponent
@onready var white_out_anim: AnimationPlayer = $WhiteOutAnim
@onready var control_hint_anim: AnimationPlayer = $ControlHintAnim

func _ready() -> void:
	Events.do_drums.emit(true)
	Events.change_melody.emit("norm")
	
	Events.complete_game.connect(_complete_game)
	if no_wave:
		return
	control_hint_anim.play("control_hint")

func _on_player_player_death() -> void:
	GameManager.load_next_level(next_level_path)

func _on_count_down_animation_finished(anim_name: StringName) -> void:
	if anim_name == "wave_countdown":
		wave_manager.start_random_wave()

func _on_asteroid_spawner_asteroid_belt_incoming(_small_count: int, _big_count: int) -> void:
	SoundBank.play_sfx("event", Vector2.ZERO)
	$AsteroidWarning.show()
	await get_tree().create_timer(1.2).timeout
	$AsteroidWarning.hide()

func _on_enemy_spawner_wave_cleared() -> void:
	print("YOU DEFEATED ALL THE ENEMIES!")
	SoundBank.play_sfx("clear", Vector2.ZERO)
	await get_tree().create_timer(1.0).timeout
	$ShopMenuComponent.show_menu()

func _on_shop_menu_component_shop_exited() -> void:
	count_down.play("wave_countdown")

func _on_entity_loomer_time_done() -> void:
	if GameManager.dispel_bought == 10:
		return
	GameManager.load_next_level(next_level_path)

func _complete_game():
	await get_tree().create_timer(3).timeout
	GameManager.load_next_level(win_path)

func _on_control_hint_anim_animation_finished(anim_name: StringName) -> void:
	$EntityLoomer.reset_scale()
	count_down.play("wave_countdown")

func _on_shop_menu_component_bought_dispel() -> void:
	white_out_anim.play("whiteout")
