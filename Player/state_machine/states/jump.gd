extends State
class_name JumpState


## Esta clase solo se encarga de vigilar cuando puede saltar y dar el impulso para ello, incluye coyote time


const COYOTE_TIME: float = 0.2
var _coyote_timer: float = 0.0


@onready var sm: PlayerStateMachine = get_parent()


func _process(_delta: float) -> void:
	if sm.current_state == sm.states['dodge']:
		return
	if sm.current_state == sm.states['onair']:
		return

	
	if sm.current_state != self:
		if Input.is_action_just_pressed('jump'):
			if _coyote_timer <= COYOTE_TIME:
				emit_signal('change_state_to', sm.current_state, 'jump')
				_coyote_timer = 0


func enter() -> void:
	sm.player.velocity.y = sm.player._jump_velocity

	sm.reset_attack_index()


func physics_process(_delta: float) -> void:
	#change state to onAir
	if _coyote_timer == 0.0 and sm.player.is_on_floor() == false:
		emit_signal('change_state_to', self, 'onair')


func _physics_process(delta: float) -> void:
	if sm.current_state != sm.states['move']:
		return

	if sm.player.is_on_floor() == false:
		_coyote_timer += delta
	else:
		_coyote_timer = 0.0

