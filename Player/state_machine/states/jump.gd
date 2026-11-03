extends State
class_name JumpState


## Esta clase maneja el estado de salto del jugador. Incluye la lógica para el salto, el tiempo de coyote,
## la aceleración y la velocidad máxima. También se encarga de cambiar al estado de idle cuando el jugador
## toca el suelo.


var coyote_time: float = 0.2
var _coyote_timer: float = 0.0
var max_speed: float = 12.0
var acceleration: float = 30.0

@onready var sm: PlayerStateMachine = get_parent()
# @onready var player: Player = owner


func _process(_delta: float) -> void:
	if sm.current_state == sm.states['dodge'] :
		return
	# if  sm.current_state == sm.states['attack']:
		# return

	
	if sm.current_state != self:
		if Input.is_action_just_pressed('jump'):
			if _coyote_timer <= coyote_time:
				emit_signal('change_state_to', sm.current_state, self.name.to_lower())
				_coyote_timer = 0


func enter() -> void:
	sm.player.velocity.y = sm.player._jump_velocity

	# reset attack indexes
	sm.normal_attack_index = 0
	sm.heavy_attack_index = 0


func physics_process(_delta: float) -> void:
	move_on_air(_delta)

	# Change state to idle
	if sm.player.is_on_floor():
		emit_signal('change_state_to', self, 'idle')


func _physics_process(delta: float) -> void:
	if sm.current_state != sm.states['move']:
		return

	if sm.player.is_on_floor() == false:
		_coyote_timer += delta
	else:
		_coyote_timer = 0.0


func move_on_air(_delta:float)->void:
	var input := sm.player.get_input()

	var direction := (sm.player.transform.basis * Vector3(
		input.x,
		0.0,
		input.y
	)).normalized()
	# Rotates toward camera
	direction = direction.rotated(
		Vector3.UP,
		sm.player.camera.global_rotation.y
	)

	if direction.length() > 0.0:
		var target_velocity = direction * max_speed

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
