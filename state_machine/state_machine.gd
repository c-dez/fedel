extends Node
class_name StateMachine
# Documentacion res://DOCS/sistema_de_estados_y_attaques.txt

var current_state: State
var states: Dictionary = {}
var last_state: State


func _ready() -> void:
	_set_current_state_at_ready()
	_set_states_dictionary()


func _process(delta: float) -> void:
	current_state.process(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)


func on_state_change(_current_state: State, _new_state: String) -> void:
	if _current_state != current_state:
		return

	var new_state: State = states[_new_state.to_lower()]
	# if current_state:
		# current_state.exit()

	current_state.exit()
	last_state = current_state
	new_state.enter()
	current_state = new_state


func _set_states_dictionary() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			
			child.change_state_to.connect(on_state_change)


func _set_current_state_at_ready() -> void:
	current_state = get_child(0)



