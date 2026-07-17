extends CharacterBody2D
class_name EnemyMissile

enum enemy_state { SEEKING, PRIMING, LUNGING }
var current_state: enemy_state = enemy_state.SEEKING

@onready var sprite: Sprite2D = $Sprite
@onready var debug_target: Sprite2D = $DEBUG_TARGET
@onready var health_component: HealthComponent = $HealthComponent

@export var SPEED : float = 50.0
@export var TURN_SPEED : float = 3.0
@export var FRICTION : float = 5.0
@export var LUNGE_SPEED : float = 300.0

@export var explosion_path : PackedScene = preload("uid://f3n5igu32ac3")

var target : Node2D
var target_spot : Vector2

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	sprite.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), randf_range(0.2, 0.5))

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
				health_component.take_damage(1)
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
	get_tree().get_first_node_in_group("world").add_child(explosion)
	queue_free()
