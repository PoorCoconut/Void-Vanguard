extends CharacterBody2D
class_name AsteroidBig

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $OnScreenNotifier

@export var points : int = 5
@export var rotation_speed: float = 0.0
@export var small_asteroid_path: PackedScene = preload("uid://do8jf8y45s7pp")
@export var green_explosion_path : PackedScene = preload("uid://cb0p2haf2ay11")
@export var point_visual_path : PackedScene = preload("uid://8kjvlwgpdk8j")
@export var split_speed_min: float = 30.0
@export var split_speed_max: float = 60.0

var has_been_onscreen: bool = false

func _ready() -> void:
	sprite.frame = randi_range(0, 1)
	if rotation_speed == 0.0:
		rotation_speed = randf_range(-30.0, 30.0) # gentle random tumble if not set

func launch(direction: Vector2, speed: float) -> void:
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	rotation += deg_to_rad(rotation_speed) * delta
	move_and_slide()

func _on_health_component_died() -> void:
	if randi_range(0, 1) == 0:
		SoundBank.play_sfx("explode1", Vector2.ZERO)
	else:
		SoundBank.play_sfx("explode2", Vector2.ZERO)
	_split()
	
	var point_visual : PointVisualizer = point_visual_path.instantiate()
	point_visual.global_position = global_position
	point_visual.p = points * GameManager.diff_points_mult
	get_tree().get_first_node_in_group("world").add_child(point_visual)
	queue_free()

func _split() -> void:
	var base_angle = randf_range(0, TAU)
	for i in 2:
		var small = small_asteroid_path.instantiate()
		get_tree().get_first_node_in_group("world").call_deferred("add_child", small)
		small.global_position = global_position
		
		var angle = base_angle + (i * PI) + randf_range(-0.3, 0.3)
		var direction = Vector2.RIGHT.rotated(angle)
		var speed = randf_range(split_speed_min, split_speed_max)
		small.launch(direction, speed)

func _on_on_screen_notifier_screen_entered() -> void:
	has_been_onscreen = true

func _on_on_screen_notifier_screen_exited() -> void:
	if has_been_onscreen:
		queue_free()

func _on_health_component_hp_changed(_new_hp: Variant, _max_hp: Variant) -> void:
	var hit_fx := green_explosion_path.instantiate()
	hit_fx.global_position = global_position
	get_tree().get_first_node_in_group("world").add_child(hit_fx)
