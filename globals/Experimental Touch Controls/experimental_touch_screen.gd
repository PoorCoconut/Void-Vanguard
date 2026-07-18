extends CanvasLayer
@onready var left_button: Button = %LeftButton   #turn_left
@onready var right_button: Button = %RightButton  #turn_right
@onready var up_button: Button = %UpButton        #up
@onready var down_button: Button = %DownButton    #down
@onready var atk_button: Button = %AtkButton      #shoot
@onready var mov_button: Button = %MovButton      #move

var _stored_shoot_mouse_events: Array[InputEvent] = []
var _stored_move_mouse_events: Array[InputEvent] = []

func _ready() -> void:
	hide()
	
	left_button.button_down.connect(func(): _press_action("turn_left"))
	left_button.button_up.connect(func(): _release_action("turn_left"))
	
	right_button.button_down.connect(func(): _press_action("turn_right"))
	right_button.button_up.connect(func(): _release_action("turn_right"))
	
	up_button.button_down.connect(func(): _press_action("up"))
	up_button.button_up.connect(func(): _release_action("up"))
	
	down_button.button_down.connect(func(): _press_action("down"))
	down_button.button_up.connect(func(): _release_action("down"))
	
	mov_button.button_down.connect(func(): _press_action("move"))
	mov_button.button_up.connect(func(): _release_action("move"))
	
	atk_button.pressed.connect(_on_atk_pressed)

func enable_touch_mode() -> void:
	_strip_mouse_bindings("shoot", _stored_shoot_mouse_events)
	_strip_mouse_bindings("move", _stored_move_mouse_events)
	show()

func disable_touch_mode() -> void:
	_restore_mouse_bindings("shoot", _stored_shoot_mouse_events)
	_restore_mouse_bindings("move", _stored_move_mouse_events)
	hide()

func _strip_mouse_bindings(action: StringName, storage: Array[InputEvent]) -> void:
	storage.clear()
	for event in InputMap.action_get_events(action):
		if event is InputEventMouseButton:
			storage.append(event)
	for event in storage:
		InputMap.action_erase_event(action, event)

func _restore_mouse_bindings(action: StringName, storage: Array[InputEvent]) -> void:
	for event in storage:
		InputMap.action_add_event(action, event)
	storage.clear()

func _press_action(action: StringName) -> void:
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = true
	Input.parse_input_event(ev)

func _release_action(action: StringName) -> void:
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = false
	Input.parse_input_event(ev)

func _on_atk_pressed() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.try_shoot()
