extends State

# Idle

var deceleration:float = 10.0 # TODO referenciar desde player
@onready var player : Player = owner

func process(_delta: float) -> void:
	transition_to_state()


func physics_process(_delta: float) -> void:
	player.velocity.x = move_toward(
		player.velocity.x,
		0.0,
		_delta * deceleration
	)

	player.velocity.z = move_toward(
		player.velocity.z,
		0.0,
		_delta * deceleration
	)


func transition_to_state()->void:
	if player.get_input().length() > 0.1:
		emit_signal('change_state_to', self, 'move')