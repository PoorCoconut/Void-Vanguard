extends Resource
class_name ShopConfig

@export_group("Hull")
@export var hull_costs: Array[int] = [50, 80, 120, 170, 230]

@export_group("Thruster")
@export var thruster_costs: Array[int] = [50, 80, 120, 170, 230]

@export_group("Laser")
@export var laser_costs: Array[int] = [60, 90, 130, 180, 240]

@export_group("Repair")
@export var repair_base_cost: int = 25
@export var repair_growth_multiplier: float = 1.35 
@export var repair_halve_on_shop_entry: bool = true

@export_group("Dispel")
@export var dispel_costs: Array[int] = [40, 55, 75, 100, 130, 170, 220, 280, 350, 430]
