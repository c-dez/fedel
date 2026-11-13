extends State
class_name OnAirState

## Esta clase se encarga de movimiento en el aire y de vigilar si player solicita un siguiente salto y toma la desicion de cambiar al siguiente estado idle o jump 


@export var max_speed: float = 12.0
@export var acceleration: float = 30.0
var request_next_jump: bool = false
var jump_time: float = 0.0
const JUMP_TIME: float = 0.5
@onready var sm: PlayerStateMachine = get_parent()


func enter() -> void:
	request_next_jump = false
	jump_time = 0.0


func process(delta: float) -> void:
	request_jump()
	check_request_jump(delta)


func physics_process(_delta: float) -> void:
	sm.player.move(max_speed, acceleration, _delta)
	transition_to_state()

		
func request_jump() -> void:
	if Input.is_action_just_pressed('jump'):
		request_next_jump = true


func check_request_jump(delta: float) -> void:
	if request_next_jump:
		jump_time += delta

	if jump_time >= JUMP_TIME:
		jump_time = 0.0
		request_next_jump = false


func transition_to_state() -> void:
	# cambia a idle o jump
	if sm.player.is_on_floor():
		if request_next_jump:
			emit_signal('change_state_to', self, 'jump')
		else:
			emit_signal('change_state_to', self, 'idle')