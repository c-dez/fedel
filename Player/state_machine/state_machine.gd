extends StateMachine
class_name PlayerStateMachine

## StateMachine de Player
## This state machine manages the player's different states, including normal and heavy attacks.
## It also handles input and transitions between states.


## Controlada por states de ataque, en Attack state func enter() = true / recovery state enter() = false 
var is_attacking: bool = false
var request_next_normal_attack: bool = false
var request_next_heavy_attack: bool = false
var normal_attack_index: int = 0
var heavy_attack_index: int = 0

## Pos de origen de proyectiles
@onready var muzzle: Node3D = owner.get_node('Muzzle')
@onready var player: Player = owner


func _ready() -> void:
	super._ready()
	_add_attakcs_states_to_states_dic()


func _process(_delta: float) -> void:
	super._process(_delta)
	request_normal_attack()
	start_normal_attack()

	request_heavy_attack()
	start_heavy_attack()

	
	state_label()


## Solicita ataque al presionar 'normal_attack'	
func request_normal_attack() -> void:
	if Input.is_action_just_pressed('normal_attack'):
		if player.is_on_floor():
			request_next_normal_attack = true


func request_heavy_attack() -> void:
	if Input.is_action_just_pressed('heavy_attack'):
		if player.is_on_floor():
			request_next_heavy_attack = true


## Ejecuta ataque solo si no esta atacando y es solicitado
func start_normal_attack() -> void:
	if is_attacking:
		return

	if request_next_normal_attack:
		if heavy_attack_index == 0:
			match normal_attack_index:
				0: # x
					on_state_change(current_state, 'fireballattackstate')
					combo_label('x')
				1: # x, x
					on_state_change(current_state, 'fireballattackstate')
					combo_label('x, x')
				2: # x, x, x
					on_state_change(current_state, 'fireballattackstate')
					combo_label('x, x, x')
				3:
					on_state_change(current_state, 'stompattackstate')

			request_next_normal_attack = false

# FALTA POR IMPLEMENTAR - PLANEAR RUTA DE COMBO!!1
func start_heavy_attack() -> void:
	if is_attacking:
		return

	if request_next_heavy_attack:
		if heavy_attack_index == 0:
			match normal_attack_index:
				0:
					on_state_change(current_state, 'heavyattackstate')

					combo_label('y')
				1:
					on_state_change(current_state, 'heavyattackstate')
					combo_label('x, y')
					heavy_attack_index = 1

				2:
					combo_label('x, x, y')

				3: # stomp es normal
					# on_state_change(current_state, 'stompattackstate')
					# heavy_attack_index = 2
					pass

			request_next_heavy_attack = false
		# reset_attack_index()

		elif heavy_attack_index == 1:
			combo_label('x,y,y')
			request_next_heavy_attack = false

			reset_attack_index()
		elif heavy_attack_index == 2:
			# stomp
			on_state_change(current_state, 'stompattackstate')
			request_next_heavy_attack = false


func _add_attakcs_states_to_states_dic() -> void:
	## Nodo solo usado para organizar
	var normal_attacks_states_node: Node = get_node('NormalAttacksStates')
	var heavy_attacks_states_node: Node = get_node('HeavyAttacksStates')

	for child in normal_attacks_states_node.get_children():
		if child is NormalAttackState:
			child.sm = self
			child.change_state_to.connect(on_state_change)

			states[child.name.to_lower()] = child

	for child in heavy_attacks_states_node.get_children():
		if child is HeavyAttackState:
			child.sm = self
			child.change_state_to.connect(on_state_change)

			states[child.name.to_lower()] = child


func reset_attack_index() -> void:
	normal_attack_index = 0
	heavy_attack_index = 0


# DEBUG ------------------------------------------------------
func state_label() -> void:
	var label: Label = %StateLabel
	if Input.is_action_just_pressed('debug'):
		label.visible = !label.visible

	#DEBUG
	label.text = str(
		'--STATE MACHINE-- \n',
		'State: ', current_state.name.to_upper(), '\n',
		'normal attack index(numero de ataque): ', normal_attack_index, '\n',
		'heavy attack index: ', heavy_attack_index
		)


func combo_label(string: String) -> void:
	var label: Label = %ComboLabel
	var array = []
	array.append(string)
	if Input.is_action_just_pressed('debug'):
		label.visible = !label.visible

	label.text = str(
		'ATTACK STRING \n',
		array
	)