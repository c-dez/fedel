extends State


## Tiempo que dura el recovery, durante este tiempo/2 se puede cancelar con movimiento
@export var timer_duration: float = 0.5
@onready var sm: StateMachine = get_parent()
@onready var timer: Timer = Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.connect('timeout', on_timer_timeout)


func enter() -> void:
	timer.start(timer_duration)

	
func exit() ->void:
	timer.stop()


func process(_delta: float) -> void:
	# si se mueve cancela el recovery
	if timer.time_left < timer.time_left/2:
		if sm.player.get_input().length() > 0.0:
			timer.stop()
			sm.reset_attack_index()
			emit_signal('change_state_to', self, 'idle')
			# sm.reset_attack_index()


func on_timer_timeout() -> void:
	emit_signal('change_state_to', self, 'idle')
	sm.reset_attack_index()



