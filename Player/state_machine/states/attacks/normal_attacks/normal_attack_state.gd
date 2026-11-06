extends State
class_name NormalAttackState

## Clase base para normal attacks
## Comportamiento ya definido, al heredar de esta clase solo hay que override func attack()

# referenciada en state_machine _add_normal_attacks_states_to_states_dic
var sm: PlayerStateMachine = null

@export var attack_duration: float = 1

@onready var timer: Timer = Timer.new()


func _ready() -> void:
	await get_tree().physics_frame
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.connect('timeout', _on_timer_timeout)


func enter() -> void:
	timer.start(attack_duration)
	sm.is_attacking = true
	# sm.normal_attack_index += 1
	attack()

	sm.player.velocity.x = 0
	sm.player.velocity.z = 0

	# rotate skin toward
	


func exit() -> void:
	sm.is_attacking = false
	pass

	
## Comportamiento de el ataque ejecutado en enter() e incluye sm.normal_attack_index += 1
func attack() ->void:
	pass


func _on_timer_timeout() -> void:
	emit_signal('change_state_to', self, 'recovery')