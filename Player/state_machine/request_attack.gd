extends Node


## solicita ataque State
var request_next_normal_attack:bool = false
var request_next_heavy_attack: bool = false
@onready var sm:PlayerStateMachine = get_parent()


func _process(_delta: float) -> void:
	request_normal_attack()
	start_normal_attack()

	request_heavy_attack()
	start_heavy_attack()
	pass


func request_normal_attack() ->void:
	if Input.is_action_just_pressed('normal_attack'):
		if sm.player.is_on_floor():
			request_next_normal_attack = true


func request_heavy_attack() -> void:
	if Input.is_action_just_pressed('heavy_attack'):
		if sm.player.is_on_floor():
			request_next_heavy_attack = true


func start_normal_attack() -> void:
	if sm.is_attacking:
		return

	if request_next_normal_attack:
		if sm.heavy_attack_index == 0:
			match sm.normal_attack_index:
				0: # x
					sm.on_state_change(sm.current_state, 'fireballattackstate')
					sm.combo_label('x')
				1: # x, x
					sm.on_state_change(sm.current_state, 'fireballattackstate')
					sm.combo_label('x, x')
				2: # x, x, x
					sm.on_state_change(sm.current_state, 'fireballattackstate')
					sm.combo_label('x, x, x')
				3: #stomp repeat
					sm.on_state_change(sm.current_state, 'stompattackstate')

			request_next_normal_attack = false


func start_heavy_attack() -> void:
	if sm.is_attacking:
		return
	if request_next_heavy_attack == true:
		if sm.normal_attack_index == 3:
			print('charge')
			request_next_heavy_attack = false




	