extends State

# MOVE
var max_speed: float = 10.0
var acceleration: float = 50.0
@onready var sm: PlayerStateMachine = get_parent()


func physics_process(_delta: float) -> void:
	sm.player.move(max_speed, acceleration, _delta)
	
	if sm.player.get_input() == Vector2.ZERO:
		emit_signal('change_state_to', self, 'idle')
