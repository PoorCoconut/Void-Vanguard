extends CharacterBody2D
class_name EnemyShuriken

@export var points : int = 15
@export var WRAP_MARGIN : float = 16.0
@export var green_explosion_path : PackedScene = preload("uid://cb0p2haf2ay11")
@export var point_visual_path : PackedScene = preload("uid://8kjvlwgpdk8j")
@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: Sprite2D = $Sprite
@onready var blink_anim: AnimationPlayer = $BlinkAnim

var target : Player
var SPEED : float = 100.0
var ACCELERATION : float = 10.0


func _ready() -> void:
	health_component.MAX_HP += GameManager.diff_hp
	health_component.CUR_HP = health_component.MAX_HP
	sprite.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), randf_range(0.2, 0.5))
	target = get_tree().get_first_node_in_group("player")
	hurtbox_component.knockback_received.connect(_on_knockback_received)

func _on_knockback_received(direction: Vector2, force: float):
	velocity += direction * force

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		look_at(target.global_position)
		var direction = global_position.direction_to(target.global_position)
		var desired_velocity = direction * (SPEED + GameManager.diff_speed)
		velocity = velocity.move_toward(desired_velocity, delta * ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * ACCELERATION)
	
	move_and_slide()
	global_position.x = wrapf(global_position.x, -WRAP_MARGIN, screen_size.x + WRAP_MARGIN)
	global_position.y = wrapf(global_position.y, -WRAP_MARGIN, screen_size.y + WRAP_MARGIN)

func _on_health_component_died() -> void:
	SoundBank.play_sfx("enemy_explode", global_position)
	var point_visual : PointVisualizer = point_visual_path.instantiate()
	point_visual.global_position = global_position
	point_visual.p = points * GameManager.diff_points_mult
	get_tree().get_first_node_in_group("world").add_child(point_visual)
	queue_free()

func _on_health_component_hp_changed(_new_hp: Variant, _max_hp: Variant) -> void:
	SoundBank.play_sfx("enemy_hit", global_position)
	blink_anim.play("blink")
	
	var hit_fx := green_explosion_path.instantiate()
	hit_fx.global_position = global_position
	get_tree().get_first_node_in_group("world").add_child(hit_fx)
