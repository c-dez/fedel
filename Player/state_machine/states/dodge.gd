extends State

# Dodge state

var dodge_duration: float = 0.5
@export var dodge_jump_speed: int = 5
@export var dodge_speed: float = 10.0
@onready var dodge_timer: Timer = $DodgeTimer

var last_input := Vector2.ZERO
var dodge_direction := Vector3.ZERO

@onready var player: Player = owner
@onready var sm: StateMachine = get_parent()


func _ready() -> void:
	dodge_timer.connect('timeout', _on_dodge_timer_timeout)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('dodge'):
		request_dodge()


func physics_process(delta: float) -> void:
	dodge(delta)


func enter() -> void:
	dodge_timer.start(dodge_duration)
	player.velocity.y = dodge_jump_speed


func exit() -> void:
	last_input = Vector2.ZERO


func dodge(_delta: float) -> void:
	player.velocity.x = dodge_direction.x * dodge_speed
	player.velocity.z = dodge_direction.z * dodge_speed


func request_dodge() -> void:
	if dodge_timer.time_left > 0.0:
		return

	if sm.current_state == self:
		return

	#capturar input
	last_input = player.get_input()

	if last_input.length_squared() > 0.01:
		var direction := Vector3(
			last_input.x, 0.0, last_input.y
		)

		direction = direction.rotated(
			Vector3.UP, player.camera.global_rotation.y
		)
		dodge_direction = direction.normalized()
	else:
		dodge_direction = player.camera.global_basis.z
		dodge_direction.y = 0.0
		dodge_direction = dodge_direction.normalized()

	emit_signal('change_state_to', sm.current_state, str(self.name.to_lower()))


func _on_dodge_timer_timeout() -> void:
	emit_signal('change_state_to', self, 'idle')
