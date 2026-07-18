extends CanvasLayer
@onready var left_button: Button = %LeftButton   #turn_left
@onready var right_button: Button = %RightButton  #turn_right
@onready var up_button: Button = %UpButton        #up
@onready var down_button: Button = %DownButton    #down
@onready var atk_button: Button = %AtkButton      #shoot
@onready var mov_button: Button = %MovButton      #move

func _ready() -> void:
	hide()
	
	left_button.button_down.connect(func(): Input.action_press("turn_left"))
	left_button.button_up.connect(func(): Input.action_release("turn_left"))
	
	right_button.button_down.connect(func(): Input.action_press("turn_right"))
	right_button.button_up.connect(func(): Input.action_release("turn_right"))
	
	up_button.button_down.connect(func(): Input.action_press("up"))
	up_button.button_up.connect(func(): Input.action_release("up"))
	
	down_button.button_down.connect(func(): Input.action_press("down"))
	down_button.button_up.connect(func(): Input.action_release("down"))
	
	mov_button.button_down.connect(func(): Input.action_press("move"))
	mov_button.button_up.connect(func(): Input.action_release("move"))
	
	atk_button.pressed.connect(_on_atk_pressed)

func _on_atk_pressed() -> void:
	Input.action_press("shoot")
	Input.action_release("shoot")
