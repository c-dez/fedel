extends State

# ATTACK state 


var attacks_array: Array[BasicAttack] = []
var attack_index: int = 0
var is_attacking: bool = false
var request_next_attack: bool = false


@onready var player: Player = owner
@onready var sm: StateMachine = get_parent()
@onready var timer: Timer = Timer.new()


func _ready() -> void:
	_set_attacks_array()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	

func _process(_delta: float) -> void:

	
	if sm.current_state != self:
		if Input.is_action_just_pressed('left_mouse'):
			if player.is_on_floor():
				emit_signal('change_state_to', sm.current_state, 'attack')
	if sm.current_state == self:
		if Input.is_action_just_pressed('left_mouse'):
			request_attack()
	
	attack()


func _physics_process(_delta: float) -> void:
	is_attacking = timer.time_left
	

func enter() -> void:
	player.velocity.x = 0
	player.velocity.z = 0
	timer.start(attacks_array[0].attack_duration)
	attacks_array[0].attack()
	attack_index += 1


func exit() -> void:
	attack_index = 0


func request_attack() -> void:
	if is_attacking:
		request_next_attack = true


func attack() -> void:
	var time_offset: float = 0.3
	if request_next_attack and not is_attacking:
		attacks_array[0].attack()
		timer.start(attacks_array[0].attack_duration + time_offset)
		request_next_attack = false
		attack_index += 1

		
func _set_attacks_array() -> void:
	for i in range(get_child_count()):
		if get_child(i) is BasicAttack:
			var child := get_child(i)
			attacks_array.append(child)



