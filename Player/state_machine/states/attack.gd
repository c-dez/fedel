extends State

# ATTACK state 


var attacks_array: Array[BasicAttack] = []
## numero de ataque
var attack_index: int = 0
var request_next_attack: bool = false
var attack_time: float = 0 ## tiempo desde que empezo el ataque

@onready var player: Player = owner
@onready var sm: StateMachine = get_parent()


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

	attacks_array[0].attack()
	attack_index += 1
	attack_time = 0.0


func process(_delta: float) -> void:
	if Input.is_action_just_pressed('left_mouse'):
		request_attack()


func physics_process(_delta: float) -> void:
	attack_time += _delta

	if attack_time >= attacks_array[0].attack_duration:
		if request_next_attack:
			start_attack()

	transition_to_recovery()
	

func request_attack() -> void:
	if attack_time > 0.2:
		request_next_attack = true


func start_attack() -> void:
	attack_time = 0.0
	attack_index += 1
	attacks_array[0].attack()
	request_next_attack = false


func _set_attacks_array() -> void:
	for i in range(get_child_count()):
		if get_child(i) is BasicAttack:
			var child := get_child(i)
			attacks_array.append(child)


func transition_to_recovery()->void:
	if attack_time > attacks_array[0].attack_duration + 0.5:
		emit_signal('change_state_to', self, 'recovery')