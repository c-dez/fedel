extends Node
class_name BasicAttack


@export var attack_duration:float = 1.0


## attack form script
func attack()->void:
	print(self.name, ' from script')

	


