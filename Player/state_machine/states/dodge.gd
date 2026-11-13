extends State

# Dodge state

@export var dodge_jump_speed: int = 5
@export var dodge_speed: float = 12.0

const DODGE_DURATION: float = 0.4
var last_input: Vector2 = Vector2.ZERO
var dodge_direction := Vector3.ZERO

@onready var sm: StateMachine = get_parent()
@onready var dodge_timer: Timer = $DodgeTimer


func _ready() -> void:
	dodge_timer.connect('timeout', _on_dodge_timer_timeout)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('dodge'):
		request_dodge()


func physics_process(delta: float) -> void:
	dodge(delta)


func enter() -> void:
	dodge_timer.start(DODGE_DURATION)
	sm.player.velocity.y = dodge_jump_speed


func exit() -> void:
	last_input = Vector2.ZERO


func dodge(_delta: float) -> void:
	sm.player.velocity.x = dodge_direction.x * dodge_speed
	sm.player.velocity.z = dodge_direction.z * dodge_speed


func request_dodge() -> void:
	if dodge_timer.time_left > 0.0:
		return

	if sm.current_state == self:
		return

	#capturar input
	last_input = sm.player.get_input()

	if last_input.length_squared() > 0.0:
		var direction := Vector3(
			last_input.x, 0.0, last_input.y
		)

		direction = direction.rotated(
			Vector3.UP, sm.player.camera.global_rotation.y
		)
		dodge_direction = direction.normalized()
	else:
		dodge_direction = sm.player.camera.global_basis.z
		dodge_direction.y = 0.0
		dodge_direction = dodge_direction.normalized()

	emit_signal('change_state_to', sm.current_state, 'dodge')


func _on_dodge_timer_timeout() -> void:
	emit_signal('change_state_to', self, 'idle')
