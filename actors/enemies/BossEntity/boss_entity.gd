extends CharacterBody2D
class_name EnemyBossEntity

enum enemy_state { SEEKING, PRIMING, LUNGING, DEAD }
var current_state: enemy_state = enemy_state.SEEKING
var points : int = 999999999

@onready var debug_target: Sprite2D = $DEBUG_TARGET
@onready var health_component: HealthComponent = $HealthComponent

@export var SPEED : float = 50.0
@export var TURN_SPEED : float = 3.0
@export var FRICTION : float = 5.0
@export var LUNGE_SPEED : float = 200.0

@export var explosion_path : PackedScene = preload("uid://f3n5igu32ac3")
@export var point_visual_path : PackedScene = preload("uid://8kjvlwgpdk8j")
@export var dark_death_path : PackedScene = preload("uid://bu5ghv4tf1l8y")
@onready var blink_anim: AnimationPlayer = $BlinkAnim

var target : Node2D
var target_spot : Vector2

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), randf_range(0.2, 0.5))

func _physics_process(delta: float) -> void:
	match current_state:
		enemy_state.SEEKING:
			if is_instance_valid(target):
				target_spot = target.global_position
				debug_target.global_position = target_spot
				var angle_to_target = global_position.direction_to(target_spot).angle()
				rotation = lerp_angle(rotation, angle_to_target + (PI / 2.0), TURN_SPEED * delta)
				velocity = -transform.y * SPEED
		enemy_state.PRIMING:
			velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)
			
			if velocity.length() < 5.0: 
				current_state = enemy_state.LUNGING
				
				var lunge_direction = global_position.direction_to(target_spot)
				rotation = lunge_direction.angle() + (PI / 2.0)
				velocity = lunge_direction * LUNGE_SPEED
		enemy_state.LUNGING:
			if global_position.distance_to(target_spot) < 5.0:
				current_state = enemy_state.SEEKING
		enemy_state.DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, delta * FRICTION)
	move_and_slide()

func _on_stopping_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and current_state == enemy_state.SEEKING:
		current_state = enemy_state.PRIMING

func _on_seek_timer_timeout() -> void:
	if current_state == enemy_state.SEEKING:
		current_state = enemy_state.PRIMING

func _on_health_component_died() -> void:
	var explosion := explosion_path.instantiate()
	explosion.global_position = global_position
	get_tree().get_first_node_in_group("world").call_deferred("add_child", explosion)
	var point_visual : PointVisualizer = point_visual_path.instantiate()
	point_visual.global_position = global_position
	point_visual.p = points
	get_tree().get_first_node_in_group("world").add_child(point_visual)
	queue_free()

func _on_health_component_hp_changed(_new_hp: Variant, _max_hp: Variant) -> void:
	SoundBank.play_sfx("enemy_hit", global_position)
	blink_anim.play("blink")
