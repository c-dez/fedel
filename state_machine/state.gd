extends Node
class_name State

@onready var state_machine: StateMachine = get_parent()

signal change_state_to(current_state: State, new_state: String)


func enter() -> void:
	pass


func process(_delta: float) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func exit() ->void:
	pass


# func change_state_to()->void:
	#POR QUE LA TENGO?
# 	pass