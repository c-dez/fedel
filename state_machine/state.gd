extends Node
class_name State

@warning_ignore("unused_signal")
signal change_state_to(current_state: State, new_state: String)


func enter() -> void:
	pass


func process(_delta: float) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func exit() ->void:
	pass


func transition_to_state()->void:
	
	pass