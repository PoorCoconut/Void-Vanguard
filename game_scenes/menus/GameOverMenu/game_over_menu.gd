extends Control

@export_file("*.tscn") var next_level_path : String

func _ready() -> void:
	Events.do_drums.emit(false)
	Events.change_melody.emit("none")
	SoundBank.play_sfx("game_over", Vector2.ZERO)

func _input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
		GameManager.load_next_level(next_level_path)
