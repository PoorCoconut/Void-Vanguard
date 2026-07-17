extends CharacterBody2D
class_name EnemyShuriken

@export var WRAP_MARGIN : float = 16.0
@onready var screen_size: Vector2 = get_viewport_rect().size
var target : Player
var SPEED : float = 100.0
var ACCELERATION : float = 10.0


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		look_at(target.global_position)
		var direction = global_position.direction_to(target.global_position)
		var desired_velocity = direction * SPEED
		velocity = velocity.move_toward(desired_velocity, delta * ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * ACCELERATION)
	
	move_and_slide()
	global_position.x = wrapf(global_position.x, -WRAP_MARGIN, screen_size.x + WRAP_MARGIN)
	global_position.y = wrapf(global_position.y, -WRAP_MARGIN, screen_size.y + WRAP_MARGIN)

func _on_health_component_died() -> void:
	SoundBank.play_sfx("enemy_explode", global_position)
	queue_free()
