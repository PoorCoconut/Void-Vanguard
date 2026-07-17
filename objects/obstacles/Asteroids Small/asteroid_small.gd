extends CharacterBody2D
class_name AsteroidSmall

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $OnScreenNotifier

@export var rotation_speed: float = 0.0

var has_been_onscreen: bool = false

func _ready() -> void:
	sprite.frame = randi_range(0, 7)
	if rotation_speed == 0.0:
		rotation_speed = randf_range(-30.0, 30.0)

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
	queue_free()

func _on_on_screen_notifier_screen_entered() -> void:
	has_been_onscreen = true

func _on_on_screen_notifier_screen_exited() -> void:
	if has_been_onscreen:
		queue_free()
