extends CharacterBody2D
class_name EnemyStatic

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var sprite: Sprite2D = $Sprite

var frame_array : Array = [2, 4, 5]
##Randomness
var rotation_direction : int = 1
var rotation_strength : float = 1.0

func _ready() -> void:
	sprite.scale = Vector2.ZERO
	sprite.frame = frame_array[randi_range(0, frame_array.size()-1)]
	rotation = randf_range(-360, 360)
	
	if randi_range(0,1) == 0:
		rotation_direction *= -1
	
	rotation_strength = randf_range(0.2, 1.5)
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), randf_range(0.2, 0.5))
	hurtbox_component.knockback_received.connect(_on_knockback_received)

func _on_knockback_received(direction: Vector2, force: float):
	velocity += direction * force

func _on_health_component_died() -> void:
	SoundBank.play_sfx("enemy_explode", global_position)
	queue_free()

func _process(delta: float) -> void:
	rotation += delta * rotation_direction * rotation_strength
