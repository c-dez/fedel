extends Node
@onready var attack_state:AttackState = get_parent()

func attack(combo_state:int)->void:
	if attack_state.combo_state == 1:
		print('finisher: ',combo_state)
		attack_state.normal_attack_index = 0
		attack_state.combo_state = 0
	if attack_state.combo_state == 2:
		print('finisher: ',combo_state)
		attack_state.normal_attack_index = 0
		attack_state.combo_state = 0
	if attack_state.combo_state == 3:
		print('finisher: ',combo_state)
		attack_state.normal_attack_index = 0
		attack_state.combo_state = 0
	else:
		return
		
