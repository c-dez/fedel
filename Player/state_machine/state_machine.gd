extends StateMachine
class_name PlayerStateMachine

## StateMachine de Player
## This state machine manages the player's different states, including normal and heavy attacks.
## It also handles input and transitions between states.


## Controlada por states de ataque, en Attack state func enter() = true / recovery state enter() = false 
var is_attacking: bool = false
var request_next_attack: bool = false
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
	request_normal_attack()
	start_normal_attack()

	
	debug_label()


## Solicita ataque al presionar 'normal_attack'	
func request_normal_attack() -> void:
	if Input.is_action_just_pressed('normal_attack'):
		if player.is_on_floor():
			request_next_attack = true
		

## Ejecuta ataque solo si no esta atacando y es solicitado
func start_normal_attack() -> void:
	if is_attacking:
		return

	if request_next_attack:
		match normal_attack_index:
			0: # x
				on_state_change(current_state, 'normalattackstate')
				combo_label('x')
			1: # x, x
				on_state_change(current_state, 'normalattackstate')
				combo_label('x, x')

		request_next_attack = false



	
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


func reset_attack_index() -> void:
	normal_attack_index = 0
	heavy_attack_index = 0




# DEBUG
func debug_label() -> void:
	var label: Label = %StateLabel
	if Input.is_action_just_pressed('debug'):
		label.visible = !label.visible

	#DEBUG
	label.text = str(
		'--STATE MACHINE-- \n',
		'State: ', current_state.name.to_upper(), '\n',
		'normal attack index: ', normal_attack_index
		)


func combo_label(string:String) ->void:
	var label:Label = %ComboLabel
	var array = []
	array.append(string)
	if Input.is_action_just_pressed('debug'):
		label.visible = !label.visible

	label.text = str(
		array
	)