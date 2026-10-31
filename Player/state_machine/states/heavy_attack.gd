extends State
class_name HeavyAttackState

## Clase que maneja el estado de ataque pesado del jugador.
## Este estado se encarga de ejecutar una secuencia de ataques pesados basada en el índice del ataque normal actual.
## El estado se transita a la fase de recupero una vez que se completa la secuencia de ataques.
var request_next_attack: bool = false
var attack_time: float = 0
var heavy_attack_duration: float = 1.0
var heavy_attack_index: int = 0

@onready var sm: StateMachine = get_parent()
@onready var attack_state: AttackState = sm.get_node('Attack')
@onready var player: Player = owner

func _ready() -> void:
	_set_attacks_dic()

	
func _process(_delta: float) -> void:
	if sm.current_state != self:
		if Input.is_action_just_pressed('heavy_attack'):
			if player.is_on_floor():
				emit_signal('change_state_to', sm.current_state, self.name.to_lower())


func enter() -> void:
	player.velocity.x = 0
	player.velocity.z = 0

	start_attack()


func process(_delta: float) -> void:
	if Input.is_action_just_pressed('heavy_attack'):
		request_attack()


func physics_process(_delta: float) -> void:
	attack_time += _delta

	if attack_time >= heavy_attack_duration:
		if request_next_attack:
			start_attack()

	transition_to_recovery()


func request_attack() -> void:
	if attack_time > 0.2:
		request_next_attack = true


func start_attack() -> void:
	attack_time = 0.0
	if heavy_attack_index == 0:
		if attack_state.normal_attack_index == 0:
			print('heavy 0')

		elif attack_state.normal_attack_index == 1:
			# x, y ... reset quick aoe
			print('quick aoe')
			set_normal_attack_index()
			
		elif attack_state.normal_attack_index == 2:
			# x,x,y, .... aoe
			print('aoe')
			set_normal_attack_index()
			
		elif attack_state.normal_attack_index == 3:
			# x, x, x, y ... reset
			# x,x,x,y,
			attacks_dic['stomp'].attack()
			print('stomp 1')	
			set_heavy_attack_index(+1)

	# elif heavy_attack_index == 1:
	# 	# x, x, y, y .... repite
	# 	attacks_dic['stomp'].heavy_attack()
	elif heavy_attack_index == 1:
		#x,x,y,y
		attacks_dic['stomp'].attack()
		print('stomp repetido')


	request_next_attack = false


func set_normal_attack_index(index: int = 0) -> void:
	attack_state.normal_attack_index = index


func set_heavy_attack_index(index: int = 0) -> void:
	heavy_attack_index = index


func transition_to_recovery() -> void:
	if attack_time > heavy_attack_duration + 0.5:
		emit_signal('change_state_to', self, 'recovery')


var attacks_dic: Dictionary = {}
func _set_attacks_dic() -> void:
	for child in get_children():
		if child is BasicHeavyAttack:
			attacks_dic[child.name.to_lower()] = child
