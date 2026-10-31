extends StateMachine
class_name PlayerStateMachine

## StateMachine de Player

var is_attacking: bool = false
var normal_attack_index: int = 0
var heavy_attack_index: int = 0

## Pos de origen de proyectiles
@onready var muzzle: Node3D = owner.get_node('Muzzle')
@onready var player: Player = owner


func _ready() -> void:
	super._ready()
	_add_normal_attakcs_states_to_states_dic()


func _process(_delta: float) -> void:
	super._process(_delta)
	debug_label()

	if Input.is_action_just_pressed('normal_attack'):
		# necesito request_attack()
		start_normal_attack()
	
	if Input.is_action_just_pressed('heavy_attack'):
		if player.is_on_floor() == true:
			if is_attacking:
				return
		
			on_state_change(current_state, 'heavyattack')


func debug_label() -> void:
	var label: Label = %DebugLabel
	if Input.is_action_just_pressed('debug'):
		label.visible = !label.visible

	#DEBUG
	label.text = str(
		'--STATE MACHINE-- \n',
		'State: ', current_state.name.to_upper(), '\n',
		'normal attack index: ', normal_attack_index
		)


func start_normal_attack() -> void:
		match normal_attack_index:
			0: # x
				on_state_change(current_state, 'normalattackstate')
			1: # x, x
				pass


func match_heavy_attack() -> void:
	pass


func _add_normal_attakcs_states_to_states_dic() -> void:
	## Nodo solo usado para organizar
	var normal_attacks_states_node: Node = get_node('NormalAttacksStates')

	for child in normal_attacks_states_node.get_children():
		if child is NormalAttackState:
			child.sm = self
			child.change_state_to.connect(on_state_change)

			states[child.name.to_lower()] = child
