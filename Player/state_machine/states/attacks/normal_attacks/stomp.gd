extends NormalAttackState
class_name StompAttackState


# var input: Vector2

@export var max_speed:float = 10.0
@export var acceleration:float = 50.0

func enter() -> void:
	# timer.start(attack_duration) #no uso timer para salir de state, 
	sm.is_attacking = true
	attack()

# TODO: revisar codigo comentado, implementado sm.player.move()
func attack() -> void:
	# print('stomp')
	# input = sm.player.get_input()
	sm.player.velocity.y = 5
	
	
func physics_process(_delta: float) -> void:
	# var max_speed: float = 10
	# var acceleration: float = 50
	
	if sm.player.is_on_floor():
		sm.player.velocity.x = 0.0
		sm.player.velocity.z = 0.0
		# print('sasdasd')
		emit_signal('change_state_to', self, 'recovery')
		return

	# var direction := (sm.player.transform.basis * Vector3(
	# 	input.x,
	# 	0.0,
	# 	input.y
	# )).normalized()

	# direction = direction.rotated(
	# 	Vector3.UP,
	# 	sm.player.camera.global_rotation.y

	# )
	# if direction.length() > 0.0:
	# 	var target_velocity := direction * max_speed

	# 	sm.player.velocity.x = move_toward(
	# 		sm.player.velocity.x,
	# 		target_velocity.x,
	# 		_delta * acceleration
	# 		)

	# 	sm.player.velocity.z = move_toward(
	# 		sm.player.velocity.z,
	# 		target_velocity.z,
	# 		_delta * acceleration
	# 		)

	# 	sm.player.rotate_skin_towards_move_direction(direction, 10.0, _delta)
	sm.player.move(max_speed, acceleration, _delta)