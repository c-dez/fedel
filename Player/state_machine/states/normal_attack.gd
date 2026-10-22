extends State

# NORMAL ATTACK
@onready var sm: StateMachine = get_parent()
var attack_num: int = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('left_mouse'):
		emit_signal('change_state_to', sm.current_state, 'normalattack')


func enter() -> void:
	# print(self.name)
	pass


func attack()->void:
	pass
