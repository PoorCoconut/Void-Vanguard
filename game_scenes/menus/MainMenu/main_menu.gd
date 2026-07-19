extends Control

@onready var button_play: Button = %Button_Play
@onready var button_settings: Button = %Button_Settings
@onready var button_credits: Button = %Button_Credits
@onready var button_exit: Button = %Button_Exit

@onready var slider_ma_vol: HSlider = %Slider_MaVol
@onready var slider_mu_vol: HSlider = %Slider_MuVol
@onready var slider_s_vol: HSlider = %Slider_SVol

@onready var touch_controls_button: CheckButton = %TouchControlsButton
@onready var low_detail_mode_button: CheckButton = %LowDetailModeButton
@onready var crt_shader_button: CheckButton = %CRTShaderButton

@onready var void_back: Sprite2D = $VoidBack
@onready var void_mid: Sprite2D = $VoidMid
@onready var void_front: Sprite2D = $VoidFront


@export_file("*.tscn") var next_level_path : String

func _ready() -> void:
	if GameManager.game_won:
		void_back.hide()
		void_mid.hide()
		void_front.hide()
	
	KonamiManager.reset_used_codes()
	Events.do_drums.emit(false)
	Events.change_melody.emit("none")
	GameManager.reset_game()
	
	slider_ma_vol.value = SettingsManager.master_vol
	slider_mu_vol.value = SettingsManager.music_vol
	slider_s_vol.value = SettingsManager.sfx_vol
	
	touch_controls_button.set_pressed_no_signal(SettingsManager.touch_screen)
	low_detail_mode_button.set_pressed_no_signal(SettingsManager.ldm)
	crt_shader_button.set_pressed_no_signal(SettingsManager.crt_enabled)
	
	if SettingsManager.touch_screen:
		ExperimentalTouchScreen.enable_touch_mode()
	else:
		ExperimentalTouchScreen.disable_touch_mode()
	
	if SettingsManager.crt_enabled:
		ShaderLayer.toggle_self()

func _on_button_play_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	GameManager.load_next_level(next_level_path)

func _on_button_settings_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	%SettingsContainer.show()

func _on_button_credits_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	pass

func _on_button_exit_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	get_tree().quit()

func _on_back_button_pressed() -> void:
	SoundBank.play_sfx("ui_back", Vector2.ZERO)
	%SettingsContainer.hide()
	%WarningLabel.hide()
	%NukeButton.hide()
	%ResetButton.show()

func _on_reset_button_pressed() -> void:
	SoundBank.play_sfx("ui_back", Vector2.ZERO)
	%WarningLabel.show()
	%NukeButton.show()
	%ResetButton.hide()

func _on_slider_ma_vol_value_changed(value: float) -> void:
	SettingsManager.master_vol = value
	SettingsManager.save_settings()

func _on_slider_mu_vol_value_changed(value: float) -> void:
	SettingsManager.music_vol = value
	SettingsManager.save_settings()

func _on_slider_s_vol_value_changed(value: float) -> void:
	SettingsManager.sfx_vol = value
	SettingsManager.save_settings()

func _on_nuke_button_pressed() -> void:
	SoundBank.play_sfx("long_explosion", Vector2.ZERO)
	#Reset ALL Settings to default, including player position
	%WarningLabel.hide()
	%NukeButton.hide()
	%ResetButton.show()
	
	#RESETTING AUDIO
	SettingsManager.master_vol = 1.0
	SettingsManager.music_vol = 1.0
	SettingsManager.sfx_vol = 1.0
	SettingsManager.save_settings()
	
	slider_ma_vol.value = SettingsManager.master_vol
	slider_mu_vol.value = SettingsManager.music_vol
	slider_s_vol.value = SettingsManager.sfx_vol
	
	#PLAYER POSITION [ALSO CALL YOUR "RESET PLAYER STATS" HERE]
	# Check if the save file exists, and if it does, delete it forever.
	var save_path = "user://savegame.json"
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("Save data wiped! Next run starts from the bottom.")
	
	#RESET KEYBINDS
	SettingsManager.reset_keybinds_to_default()

func _on_button_windowed_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_button_fullscreen_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_button_exclusive_fullscreen_pressed() -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

##CONTROLS SETTINGS AND STUFF
@onready var action_list_container : GridContainer = %RebindContainer
func _on_controls_reset_pressed() -> void:
	SoundBank.play_sfx("long_explosion", Vector2.ZERO)
	SettingsManager.reset_keybinds_to_default()


func _on_touch_controls_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SoundBank.play_sfx("ui_next", Vector2.ZERO)
		ExperimentalTouchScreen.enable_touch_mode()
	else:
		SoundBank.play_sfx("ui_back", Vector2.ZERO)
		ExperimentalTouchScreen.disable_touch_mode()
	SettingsManager.touch_screen = toggled_on
	SettingsManager.save_settings()

func _on_low_detail_mode_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SoundBank.play_sfx("ui_next", Vector2.ZERO)
	else:
		SoundBank.play_sfx("ui_back", Vector2.ZERO)
	SettingsManager.ldm = toggled_on
	SettingsManager.save_settings()

func _on_crt_shader_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SoundBank.play_sfx("ui_next", Vector2.ZERO)
	else:
		SoundBank.play_sfx("ui_back", Vector2.ZERO)
	SettingsManager.crt_enabled = toggled_on
	ShaderLayer.toggle_self()
	SettingsManager.save_settings()

func _on_settings_tabs_tab_clicked(tab: int) -> void:
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
