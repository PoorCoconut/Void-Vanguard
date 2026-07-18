extends CharacterBody2D
class_name Player

@export_category("PLAYER MOVEMENT")
@export var MAX_SPEED : float = 25
@export var TURN_SPEED : float = 2
@export var ACCELERATION : float = 100
@export var FRICTION : float = 0

@export_category("BULLET STATS")
@export var COOLDOWN : float = 0.5
@export var DAMAGE : int = 1
@export var BULLET_SPEED : float = 80.0
var on_cooldown : bool = false

@export_category("COMPONENTS")
@export var hurtbox_component : HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent

@export_category("OTHERS")
@export var WRAP_MARGIN : float = 16.0

@onready var blink_anim: AnimationPlayer = $BlinkAnim
@onready var accelerate_sfx: AudioStreamPlayer = $AccelerateSFX
@onready var gas_particles: CPUParticles2D = %GasParticles
@onready var screen_size: Vector2 = get_viewport_rect().size

const bullet_path : PackedScene = preload("res://objects/Bullets/Player Bullet/player_bullet.tscn")
var CUR_DIR : Vector2
var secret_cooldown : float = 0

func _ready() -> void:
	KonamiManager.code_entered.connect(kon_codes)
	hurtbox_component.knockback_received.connect(_on_knockback_received)
	accelerate_sfx.volume_db = -5
	Events.player_hp_updated.emit(health_component.CUR_HP, health_component.MAX_HP)
	Events.bought_hull_upgrade.connect(add_max_hp)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		try_shoot()

func try_shoot() -> void:
	if on_cooldown:
		return
	on_cooldown = true
	SoundBank.play_sfx("shoot", global_position)
	var bullet: Bullet = bullet_path.instantiate()
	bullet.SPEED = BULLET_SPEED
	bullet.ROTA = rotation
	get_tree().get_first_node_in_group("world").add_child(bullet)
	bullet.global_position = %NosePoint.global_position
	
	await get_tree().create_timer(COOLDOWN + GameManager.laser_cooldown + secret_cooldown).timeout
	on_cooldown = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("turn_left"):
		rotation -= 1 * (TURN_SPEED + GameManager.thruster_turn) * delta
	elif Input.is_action_pressed("turn_right"):
		rotation += 1 * (TURN_SPEED + GameManager.thruster_turn) * delta
	
	if Input.is_action_pressed("move"):
		gas_particles.emitting = true
		velocity = velocity.move_toward(-transform.y * (MAX_SPEED + GameManager.thruster_speed), ACCELERATION * delta)
		accelerate_sfx.pitch_scale = clampf(accelerate_sfx.pitch_scale + 0.01, 0.1, 0.5)
	else:
		gas_particles.emitting = false
		velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)
		accelerate_sfx.pitch_scale = clampf(accelerate_sfx.pitch_scale - 0.01, 0.1, 0.5)
	move_and_slide()
	global_position.x = wrapf(global_position.x, -WRAP_MARGIN, screen_size.x + WRAP_MARGIN)
	global_position.y = wrapf(global_position.y, -WRAP_MARGIN, screen_size.y + WRAP_MARGIN)

func _on_knockback_received(direction: Vector2, force: float):
	velocity += direction * force

func _on_health_component_hp_changed(new_hp: Variant, max_hp: Variant) -> void:
	GameManager.do_camera_shake(5.0, 0.5)
	blink_anim.play("blink")
	SoundBank.play_sfx("player_hit", global_position)
	Events.player_hp_updated.emit(new_hp, max_hp)

signal player_death
func _on_health_component_died() -> void:
	hurtbox_component.iframe = 100
	player_death.emit()
	GameManager.do_camera_shake(10.0, 1)
	SoundBank.play_sfx("player_death", global_position)
	print("PLAYER DIED!")

func add_max_hp():
	health_component.MAX_HP += 1
	health_component.CUR_HP += 1

func kon_codes(code_name : String):
	if code_name == "classic":
		secret_cooldown = -1.0
		await get_tree().create_timer(5.0).timeout
		secret_cooldown = 0
	elif code_name == "cross":
		health_component.take_damage(-100)
