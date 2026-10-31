extends Node
class_name BasicAttack


@export var attack_duration:float = 0.2

@onready var fireball :PackedScene = preload('/home/gato/Documents/godot/fedel/fireball/fireball.tscn')

@onready var attack_state:AttackState = get_parent()

## attack form script
func attack()->void:
	# print(self.name, ' from base script')
	var f :FireBall= fireball.instantiate()
	attack_state.sm.muzzle.add_child(f)
	f.current_target = %TargetArea.current_target


	


