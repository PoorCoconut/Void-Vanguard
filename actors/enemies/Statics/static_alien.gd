extends CharacterBody2D
class_name EnemyStatic

@export var points : int = 5
@export var green_explosion_path : PackedScene = preload("uid://cb0p2haf2ay11")
@export var point_visual_path : PackedScene = preload("uid://8kjvlwgpdk8j")
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: Sprite2D = $Sprite
@onready var blink_anim: AnimationPlayer = $BlinkAnim

var frame_array : Array = [2, 4, 5]
##Randomness
var rotation_direction : int = 1
var rotation_strength : float = 1.0

func _ready() -> void:
	hitbox_component.damage += GameManager.diff_dmg
	sprite.frame = frame_array[randi_range(0, frame_array.size()-1)]
	
	sprite.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), randf_range(0.2, 0.5))
	
	rotation = randf_range(-360, 360)
	
	if randi_range(0,1) == 0:
		rotation_direction *= -1
	
	rotation_strength = randf_range(0.2, 1.5)
	hurtbox_component.knockback_received.connect(_on_knockback_received)

func _on_knockback_received(direction: Vector2, force: float):
	velocity += direction * force

func _on_health_component_hp_changed(_new_hp: Variant, _max_hp: Variant) -> void:
	SoundBank.play_sfx("enemy_hit", global_position)
	blink_anim.play("blink")
	
	var hit_fx := green_explosion_path.instantiate()
	hit_fx.global_position = global_position
	get_tree().get_first_node_in_group("world").add_child(hit_fx)

func _on_health_component_died() -> void:
	SoundBank.play_sfx("enemy_explode", global_position)
	var point_visual : PointVisualizer = point_visual_path.instantiate()
	point_visual.global_position = global_position
	point_visual.p = points * GameManager.diff_points_mult
	get_tree().get_first_node_in_group("world").add_child(point_visual)
	queue_free()

func _process(delta: float) -> void:
	rotation += delta * rotation_direction * rotation_strength
