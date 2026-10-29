extends Node
class_name BasicAttack


@export var attack_duration:float = 1.0


## attack form script
func attack()->void:
	print(self.name, ' from script')
	# print(get_parent().combo_state,' combo state \n',
	# get_parent().normal_attack_index, ' normal attack index')

	


