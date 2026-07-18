extends CanvasLayer
@onready var left_touch_screen: TouchScreenButton = %LeftTouchScreen
@onready var right_touch_screen: TouchScreenButton = %RightTouchScreen
@onready var up_touch_screen: TouchScreenButton = %UpTouchScreen
@onready var down_touch_screen: TouchScreenButton = %DownTouchScreen
@onready var atk_touch_screen: TouchScreenButton = %AtkTouchScreen
@onready var mov_touch_screen: TouchScreenButton = %MovTouchScreen

var _stored_shoot_mouse_events: Array[InputEvent] = []
var _stored_move_mouse_events: Array[InputEvent] = []

func _ready() -> void:
	hide()
	
	left_touch_screen.pressed.connect(func(): _press_action("turn_left"))
	left_touch_screen.released.connect(func(): _release_action("turn_left"))
	
	right_touch_screen.pressed.connect(func(): _press_action("turn_right"))
	right_touch_screen.released.connect(func(): _release_action("turn_right"))
	
	up_touch_screen.pressed.connect(func(): _press_action("up"))
	up_touch_screen.released.connect(func(): _release_action("up"))
	
	down_touch_screen.pressed.connect(func(): _press_action("down"))
	down_touch_screen.released.connect(func(): _release_action("down"))
	
	mov_touch_screen.pressed.connect(func(): _press_action("move"))
	mov_touch_screen.released.connect(func(): _release_action("move"))
	
	atk_touch_screen.pressed.connect(_on_atk_pressed)

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
	_press_action("shoot")
	_release_action("shoot")
