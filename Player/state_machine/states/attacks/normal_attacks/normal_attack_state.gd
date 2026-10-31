extends State
class_name NormalAttackState

## Clase base para normal attacks


var sm: PlayerStateMachine = null

@export var attack_duration: float = 0.5

@onready var timer: Timer = Timer.new()


func _ready() -> void:
	await get_tree().physics_frame
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.connect('timeout', _on_timer_timeout)


func enter() -> void:
	timer.start(attack_duration)
	sm.normal_attack_index += 1
	sm.is_attacking = true


func exit() -> void:
	sm.is_attacking = false


func _on_timer_timeout() -> void:
	emit_signal('change_state_to', self, 'recovery')