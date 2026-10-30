extends Node3D
class_name AttackManager


##Combo no se rompe por pasar tiempo sin input
## Se rompe al moverse
## excepto al dodge

var attack_nodes: Dictionary = {}
enum ComboState {
	NO_ATTACK,
	ATTACKING,
	STOMP,
	CHARGE,
	CLAWS,
	ORBS
}

var combo_state: ComboState = ComboState.NO_ATTACK
var combo_index: int = 0

var attack_time: float = 0.0 ## Tiempo transcurrido desde que empezo el ataque
var attack_durations: Array[float] = [
	0.5,
	0.8 # attack 2
]

var next_attack_requested: bool = false
@onready var spring_arm_pivot: Node3D = owner.get_node('SpringArmPivot')

var is_attacking: bool = false


func _ready() -> void:
	set_attack_nodes()


func _process(delta: float) -> void:
	_set_rotation_y()

	# input de player para ejecutar ataques
	normal_attack_input(delta)
	heavy_attack_input(delta)


func _physics_process(_delta: float) -> void:
	#DEBUG
	debug_label()
	reset_combo_move()

	check_if_can_start_attack(_delta)


## modifica var next_attack_requested:bool, 
func request_attack(_delta: float) -> void:
	if combo_state == ComboState.NO_ATTACK:
		combo_state = ComboState.ATTACKING
		start_attack(combo_index)
		return
	#evita que se pueda iniciar ataque en los primeros 0.2 seg
	if attack_time > 0.2:
		if combo_state == ComboState.ATTACKING:
			next_attack_requested = true
			combo_index += 1
		elif combo_state == ComboState.STOMP:
			next_attack_requested = true
			combo_index += 1

		if combo_state == ComboState.CHARGE:
			next_attack_requested = true
		#claws
		if combo_state == ComboState.CLAWS:
			next_attack_requested = true
			combo_index += 1
		

## Comienza ataque y decide que ataque ejecutar
func start_attack(index: int) -> void:
	combo_index = index
	attack_time = 0.0
	next_attack_requested = false

	# rotate skin towards camera dir
	var direction: Vector3 = - owner.camera.global_basis.z
	direction.y = 0.0
	direction = direction.normalized()
	
	var target_angle := atan2(direction.x, direction.z) + PI
	owner.skin.rotation.y = target_angle
	# --------------------------------
	
	if combo_state == ComboState.ATTACKING:
		match index:
			0:
				attack_nodes['proyectile'].fire_proyectile(self)
			1:
				attack_nodes['proyectile'].fire_proyectile(self)
			2:
				attack_nodes['proyectile'].fire_proyectile(self)
				
			3:
				# de inmediato salta a siguiente match
				index = 0
				combo_index = index
				combo_state = ComboState.STOMP
				
	if combo_state == ComboState.STOMP:
		match index:
			0:
				attack_nodes['stomp'].request_stomp()
				print('stomp 0 ', index)

			_:
				attack_nodes['stomp'].request_stomp()
				print('stomp _', index)

	if combo_state == ComboState.CHARGE:
		attack_nodes['charge'].charge()

	# if combo_state == ComboState.CLAWS:
	# 	if index > 0:
	# 		index = 0
	# 		combo_index = index
	# 	match index:
	# 		0:
	# 			attack_nodes['claws'].claws()
	# 			print('clws 0 ', index)
	# 		_:
	# 			attack_nodes['claws'].claws()


func reset_combo() -> void:
	combo_state = ComboState.NO_ATTACK
	combo_index = 0
	attack_time = 0.0
	next_attack_requested = false
	is_attacking = false
	print('combo reset')

	
func reset_combo_move() -> void:
	#si se esta en state attacking, si se mueve reset combo
	if combo_state == ComboState.ATTACKING:
		if owner.get_input().length() > 0.0:
			reset_combo()
	if combo_state == ComboState.STOMP:
		if Input.is_action_just_pressed('jump'):
			reset_combo()
	if owner.dodge_component.is_dodging:
		return


## agrega los hijos de attaques a dictionary attack_nodes{}	
func set_attack_nodes() -> void:
	for i in range(get_child_count()):
		attack_nodes[str(get_child(i).name.to_lower())] = get_child(i)

## DEBUG 
func debug_label() -> void:
	var label: Label = %DebugLabel
	var text: String = 'no attack'
	# NO_ATTACK,
	# ATTACKING,
	# STOMP,
	# CHARGE,
	# CLAWS,
	# ORBS
	match combo_state:
		0:
			text = 'no attack'
		1:
			text = ' attacking'
		2:
			text = 'stomp'
		3:
			text = 'charge'
		4:
			text = 'claws'
		5:
			text = 'orbs'
			
	label.text = text


## checa el attack_time y la ventana de tiempo de attack_durations[] para decidir si  request_attack es valido
func check_if_can_start_attack(delta: float) -> void:
	if combo_state == ComboState.NO_ATTACK:
		return

	attack_time += delta

	if attack_time >= attack_durations[1]: # TODO: ATTACK_DURATION[HARDCODE]
		if next_attack_requested:
			start_attack(combo_index)

	is_attacking = attack_time <= attack_durations[1] + 0.2 and attack_time > 0.0


func _set_rotation_y() -> void:
	rotation.y = spring_arm_pivot.rotation.y


func normal_attack_input(delta: float) -> void:
	if Input.is_action_just_pressed('attack'):
		# ignora si es state charge
		if combo_state == ComboState.CHARGE:
			return

		request_attack(delta)


func heavy_attack_input(delta: float) -> void:
	if Input.is_action_just_pressed('heavy_attack'):
		# continua el combo de stomp a charge
		if combo_state == ComboState.STOMP:
			combo_state = ComboState.CHARGE
			request_attack(delta)