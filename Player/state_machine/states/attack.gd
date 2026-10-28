extends State
class_name AttackState
## ATTACK state 


var attacks_array: Array[BasicAttack] = []

var request_next_attack: bool = false
var attack_time: float = 0 ## tiempo desde que empezo el ataque

@onready var player: Player = owner
@onready var sm: StateMachine = get_parent()


# test
var normal_attack_index: int = 0
var heavy_attack_index: int = 0

var max_normal_attacks_index:int = 0

func _ready() -> void:
	_set_attacks_array()


func _process(_delta: float) -> void:
	if sm.current_state != self:
		if Input.is_action_just_pressed('left_mouse'):
			if player.is_on_floor():
				emit_signal('change_state_to', sm.current_state, 'attack')


func enter() -> void:
	player.velocity.x = 0
	player.velocity.z = 0

	start_attack()


func process(_delta: float) -> void:
	if Input.is_action_just_pressed('left_mouse'):
		request_attack()


func physics_process(_delta: float) -> void:
	attack_time += _delta

	if attack_time >= attacks_array[normal_attack_index-1].attack_duration:
		if request_next_attack:
			start_attack()

	transition_to_recovery()
	

func request_attack() -> void:
	if attack_time > 0.2:
		request_next_attack = true


func start_attack() -> void:
	if normal_attack_index >= max_normal_attacks_index:
		# attack_index = 0
		normal_attack_index = 0
		print('reset normal attack index')

	attack_time = 0.0
	attacks_array[normal_attack_index].attack()
	request_next_attack = false
	# attack_index += 1
	normal_attack_index += 1


func _set_attacks_array() -> void:
	for i in range(get_child_count()):
		if get_child(i) is BasicAttack:
			var child := get_child(i)
			attacks_array.append(child)
			max_normal_attacks_index += 1
 

func transition_to_recovery() -> void:
	if attack_time > attacks_array[0].attack_duration + 0.5:
		emit_signal('change_state_to', self, 'recovery')
