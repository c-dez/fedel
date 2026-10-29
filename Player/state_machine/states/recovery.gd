extends State

var attack_index: int = 0
var timer_duration: float = 1.0
@onready var sm: StateMachine = get_parent()
@onready var timer: Timer = Timer.new()
@onready var player: Player = owner


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
	if player.get_input().length() > 0.0:
		timer.stop()
		reset_attack_index()
		emit_signal('change_state_to', self, 'idle')


func on_timer_timeout() -> void:
	emit_signal('change_state_to', self, 'idle')
	reset_attack_index()


func reset_attack_index() -> void:
	sm.states['attack'].normal_attack_index = 0
	sm.states['attack'].combo_state = 0

