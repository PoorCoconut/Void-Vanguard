extends CanvasLayer

func _ready() -> void:
	toggle_self()

func toggle_self():
	if SettingsManager.crt_enabled:
		show()
	else:
		hide()
