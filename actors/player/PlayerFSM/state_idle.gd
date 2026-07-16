extends "res://systems/FSM/State.gd"
class_name PlayerIdle

func enterState():
	pass

func updateState(_delta : float):
	if Input.is_action_just_pressed("turn_left") or Input.is_action_just_pressed("turn_right"):
		pass
	
	pass
