extends Node
class_name AsteroidSpawner

signal asteroid_belt_incoming(small_count: int, big_count: int)
signal asteroid_belt_spawned

@export var spawn_area: Rect2 = Rect2(0, 0, 320, 180)
@export var offscreen_margin: float = 30.0
@export var warning_delay: float = 1.5 # seconds between warning and actual spawn

func spawn_belt(wave: Wave) -> void:
	if not wave.has_asteroid_belt:
		return
	
	asteroid_belt_incoming.emit(wave.small_asteroid_count, wave.big_asteroid_count)
	
	if warning_delay > 0.0:
		await get_tree().create_timer(warning_delay).timeout
	
	for i in wave.small_asteroid_count:
		_spawn_asteroid(wave.small_asteroid_scene, wave)
	for i in wave.big_asteroid_count:
		_spawn_asteroid(wave.big_asteroid_scene, wave)
	
	asteroid_belt_spawned.emit()

func _spawn_asteroid(scene: PackedScene, wave: Wave) -> void:
	if not scene:
		return
	
	var asteroid = scene.instantiate()
	get_tree().current_scene.add_child(asteroid)
	
	var spawn_pos = _get_offscreen_position()
	asteroid.global_position = spawn_pos
	
	var target = Vector2(
		randf_range(spawn_area.position.x, spawn_area.end.x),
		randf_range(spawn_area.position.y, spawn_area.end.y)
	)
	var direction = (target - spawn_pos).normalized()
	var speed = randf_range(wave.asteroid_speed_min, wave.asteroid_speed_max)
	
	if asteroid.has_method("launch"):
		asteroid.launch(direction, speed)

func _get_offscreen_position() -> Vector2:
	var edge = randi() % 4
	match edge:
		0: return Vector2(randf_range(spawn_area.position.x, spawn_area.end.x), spawn_area.position.y - offscreen_margin)
		1: return Vector2(spawn_area.end.x + offscreen_margin, randf_range(spawn_area.position.y, spawn_area.end.y))
		2: return Vector2(randf_range(spawn_area.position.x, spawn_area.end.x), spawn_area.end.y + offscreen_margin)
		_: return Vector2(spawn_area.position.x - offscreen_margin, randf_range(spawn_area.position.y, spawn_area.end.y))
