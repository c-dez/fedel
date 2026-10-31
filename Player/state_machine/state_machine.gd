extends StateMachine
class_name PlayerStateMachine

@onready var muzzle: Node3D = owner.get_node('Muzzle')

@onready var player: Player = owner

var is_attacking: bool = false
var normal_attack_index: int = 0
var heavy_attack_index: int = 0
## Diccionario que almacena los ataques normales
var normal_attacks_states:Dictionary = {}

func _ready() -> void:
	super._ready()
	_set_normal_attacks_states_dictionary()
	print(normal_attacks_states)


func _process(_delta: float) -> void:
	super._process(_delta)

	debug_label()

	if Input.is_action_just_pressed('normal_attack'):
		match_normal_attack()
	
	if Input.is_action_just_pressed('heavy_attack'):
		if player.is_on_floor() == true:
			if is_attacking:
				return
		
			on_state_change(current_state, 'heavyattack')


func debug_label() -> void:
	#DEBUG
	var label: Label = %DebugLabel
	label.text = str(
		'state: ', current_state.name,
		
		
		)
	#----------------	


func match_normal_attack()->void:
	pass


func match_heavy_attack() ->void:
	pass


func _set_normal_attacks_states_dictionary()->void:
	var normal_attacks_states_node:Node = get_node('NormalAttacksStates')

	for child in normal_attacks_states_node.get_children():
		if child is State:
			normal_attacks_states[child.name.to_lower()] = child

			child.change_state_to.connect(on_state_change)
