extends CanvasLayer
class_name ShopMenuComponent

@export var config: ShopConfig
@export var player: Player
@export var debug_points: bool = false
@export var debug_menu : bool = false

@onready var hull_cost: Label = %HullCost
@onready var hull_progress_bar: TextureProgressBar = %HullProgressBar
@onready var hull_button: TextureButton = %HullButton

@onready var thruster_cost: Label = %ThrusterCost
@onready var thruster_progress_bar: TextureProgressBar = %ThrusterProgressBar
@onready var thruster_button: TextureButton = %ThrusterButton

@onready var laser_cost: Label = %LaserCost
@onready var laser_progress_bar: TextureProgressBar = %LaserProgressBar
@onready var laser_button: TextureButton = %LaserButton

@onready var repair_cost: Label = %RepairCost
@onready var repair_button: TextureButton = %RepairButton

@onready var dispel_cost: Label = %DispelCost
@onready var dispel_button: TextureButton = %DispelButton

@onready var entity_progress: ProgressBar = %EntityProgress
@onready var player_points: Label = %PlayerPoints

var current_repair_cost: float
signal shop_exited
func _ready() -> void:
	if debug_points:
		GameManager.points += 999999
	current_repair_cost = config.repair_base_cost

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug") and debug_menu:
		show_menu()

func show_menu() -> void:
	if config.repair_halve_on_shop_entry:
		current_repair_cost = max(config.repair_base_cost, current_repair_cost / 2.0)
	
	update_entity_progress()
	refresh_ui()
	SoundBank.play_sfx("ui_next", Vector2.ZERO)
	self.show()
	get_tree().paused = true

func hide_menu() -> void:
	print("hide the menu!")
	SoundBank.play_sfx("ui_back", Vector2.ZERO)
	self.hide()
	get_tree().paused = false
	shop_exited.emit()

func refresh_ui() -> void:
	player_points.text = str(GameManager.points) + " P"
	
	# Hull
	if GameManager.hull_upgraded < config.hull_costs.size():
		hull_cost.text = str(config.hull_costs[GameManager.hull_upgraded]) + " P"
		hull_button.disabled = GameManager.points < config.hull_costs[GameManager.hull_upgraded]
	else:
		hull_cost.text = "MAX"
		hull_button.disabled = true
	
	# Thruster
	if GameManager.thruster_upgraded < config.thruster_costs.size():
		thruster_cost.text = str(config.thruster_costs[GameManager.thruster_upgraded]) + " P"
		thruster_button.disabled = GameManager.points < config.thruster_costs[GameManager.thruster_upgraded]
	else:
		thruster_cost.text = "MAX"
		thruster_button.disabled = true
	
	# Laser
	if GameManager.laser_upgraded < config.laser_costs.size():
		laser_cost.text = str(config.laser_costs[GameManager.laser_upgraded]) + " P"
		laser_button.disabled = GameManager.points < config.laser_costs[GameManager.laser_upgraded]
	else:
		laser_cost.text = "MAX"
		laser_button.disabled = true
	
	# Repair
	var repair_maxed = player.health_component and player.health_component.CUR_HP >= player.health_component.MAX_HP
	if repair_maxed:
		repair_cost.text = "FULL"
		repair_button.disabled = true
	else:
		repair_cost.text = str(int(current_repair_cost)) + " P"
		repair_button.disabled = GameManager.points < current_repair_cost
	
	# Dispel
	if GameManager.dispel_bought < config.dispel_costs.size():
		dispel_cost.text = str(config.dispel_costs[GameManager.dispel_bought]) + " P"
		dispel_button.disabled = GameManager.points < config.dispel_costs[GameManager.dispel_bought]
	else:
		dispel_cost.text = "MAX"
		dispel_button.disabled = true

func _on_hull_button_pressed() -> void:
	if GameManager.hull_upgraded >= config.hull_costs.size():
		return
	var cost = config.hull_costs[GameManager.hull_upgraded]
	if GameManager.points < cost:
		return
	
	GameManager.points -= cost
	GameManager.hull_upgraded += 1
	GameManager.hull_health += 1
	hull_progress_bar.value += 1
	SoundBank.play_sfx("ui_buy", Vector2.ZERO)
	refresh_ui()

func _on_thruster_button_pressed() -> void:
	if GameManager.thruster_upgraded >= config.thruster_costs.size():
		return
	var cost = config.thruster_costs[GameManager.thruster_upgraded]
	if GameManager.points < cost:
		return
	
	GameManager.points -= cost
	
	if GameManager.thruster_upgraded == 0:
		GameManager.thruster_speed += 0.01
		GameManager.thruster_turn += 10.0
	elif GameManager.thruster_upgraded == 1:
		GameManager.thruster_turn += 0.01
	elif GameManager.thruster_upgraded == 2:
		GameManager.thruster_turn += 0.05
		GameManager.thruster_speed += 25.0
	elif GameManager.thruster_upgraded == 3:
		GameManager.thruster_turn += 0.01
	elif GameManager.thruster_upgraded == 4:
		GameManager.thruster_turn += 0.01
		GameManager.thruster_speed += 25.0
	
	GameManager.thruster_upgraded += 1
	thruster_progress_bar.value += 1
	SoundBank.play_sfx("ui_buy", Vector2.ZERO)
	refresh_ui()

func _on_laser_button_pressed() -> void:
	if GameManager.laser_upgraded >= config.laser_costs.size():
		return
	var cost = config.laser_costs[GameManager.laser_upgraded]
	if GameManager.points < cost:
		return
	
	GameManager.points -= cost
	
	if GameManager.laser_upgraded == 0:
		GameManager.laser_cooldown -= 0.1
	elif GameManager.laser_upgraded == 1:
		GameManager.laser_cooldown -= 0.1
	elif GameManager.laser_upgraded == 2:
		GameManager.laser_damage += 1
		GameManager.laser_cooldown -= 0.1
	elif GameManager.laser_upgraded == 3:
		GameManager.laser_cooldown -= 0.1
	elif GameManager.laser_upgraded == 4:
		GameManager.laser_damage += 1
		GameManager.laser_cooldown -= 0.1
	
	GameManager.laser_upgraded += 1
	laser_progress_bar.value += 1
	SoundBank.play_sfx("ui_buy", Vector2.ZERO)
	refresh_ui()

func _on_repair_button_pressed() -> void:
	if not player or player.health_component.CUR_HP >= player.health_component.MAX_HP:
		return
	if GameManager.points < current_repair_cost:
		return
	
	GameManager.points -= int(current_repair_cost)
	player.health_component.take_damage(-1)
	current_repair_cost *= config.repair_growth_multiplier
	SoundBank.play_sfx("ui_buy", Vector2.ZERO)
	refresh_ui()

func _on_dispel_button_pressed() -> void:
	if GameManager.dispel_bought >= config.dispel_costs.size():
		return
	var cost = config.dispel_costs[GameManager.dispel_bought]
	if GameManager.points < cost:
		return
	
	GameManager.points -= cost
	
	if GameManager.dispel_bought == 5:
		GameManager.difficulty = "m"
	elif GameManager.dispel_bought == 8:
		GameManager.difficulty = "h"
	
	GameManager.dispel_bought += 1
	SoundBank.play_sfx("dispell", Vector2.ZERO)
	hide_menu()

func update_entity_progress() -> void:
	pass

func _on_continue_button_pressed() -> void:
	hide_menu()
