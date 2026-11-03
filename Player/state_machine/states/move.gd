extends State

# MOVE
var max_speed: float = 10.0
var acceleration: float = 50.0
# @onready var player: Player = owner
@onready var sm: PlayerStateMachine = get_parent()

func physics_process(_delta: float) -> void:
	# if sm.is_attacking:
	# 	return
	var input = sm.player.get_input()

	var direction := (sm.player.transform.basis * Vector3(
		input.x,
		0.0,
		input.y
	)).normalized()
	#Rotates toward camera
	direction = direction.rotated(
		Vector3.UP,
		sm.player.camera.global_rotation.y
	)

	if direction.length() > 0.0:
		var target_velocity := direction * max_speed

		sm.player.velocity.x = move_toward(
			sm.player.velocity.x,
			target_velocity.x,
			_delta * acceleration
			)

		sm.player.velocity.z = move_toward(
			sm.player.velocity.z,
			target_velocity.z,
			_delta * acceleration
			)

		sm.player.rotate_skin_towards_move_direction(direction, 10.0, _delta)
	else:
		# Change state to idle
		emit_signal('change_state_to', self, 'idle')
