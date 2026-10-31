extends BasicHeavyAttack


var capture_input := Vector2.ZERO
var direction := Vector3.ZERO

@onready var heavy_attack_state :HeavyAttackState = get_parent()

func attack() -> void:
	owner.velocity.y = 5
	capture_input = owner.get_input()
	# direction = Vector3(
	# 	capture_input.x, 0.0, capture_input.y
	# )

# hacer state machines para ataques>???
# PROBLEMA SIEMPRE QUE ESTE EJECUTANDO HEAVY ATTACKS VA A EJECUTAR ESTE CODIGO!!!1
func _physics_process(_delta: float) -> void:
	# if get_parent().sm.current_state != get_parent().sm.states['heavyattack']:
	# 	return
	if heavy_attack_state.sm.current_state != heavy_attack_state.sm.states['heavyattack']:
		return

	direction = Vector3(
		capture_input.x, 0.0, capture_input.y
	)
	direction = direction.rotated(
		Vector3.UP,
		owner.camera.global_rotation.y
	)
	if owner.is_on_floor() == false:
		owner.velocity.x = direction.x * 5
		owner.velocity.z = direction.z * 5
	else:
		owner.velocity.x = 0
		owner.velocity.z = 0
