extends Node

var dodge_duration: float = 0.5
@export var dodge_jump_speed: int = 5
@export var dodge_speed: float = 10.0
@onready var dodge_timer: Timer = $DodgeTimer


var is_dodging: bool = false
var last_input := Vector2.ZERO
var dodge_direction := Vector3.ZERO
func _ready() -> void:
	#timer signal
	dodge_timer.connect('timeout', _on_dodge_timer_timeout)
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('dodge'):
		request_dodge()


func _physics_process(delta: float) -> void:
	dodge(delta)

	
func request_dodge() -> void:
	if dodge_timer.time_left > 0:
		return

	#capturar input
	last_input = Input.get_vector(
		'left', 'right',
		'up','down'
	)

	# convertir input en direccion 
	if last_input.length_squared() > 0.01:
		var direction := Vector3(last_input.x, 0.0, last_input.y)

		direction = direction.rotated(Vector3.UP, owner.camera.global_rotation.y)
		dodge_direction = direction.normalized()
	else:
		# sin input, hacia atras respecto a personaje
		dodge_direction = owner.camera.global_basis.z
		dodge_direction.y = 0.0
		dodge_direction = dodge_direction.normalized()

	dodge_timer.start(dodge_duration)

	# pequeno salto
	owner.velocity.y = dodge_jump_speed


func dodge(_delta: float) -> void:
	is_dodging = dodge_timer.time_left > 0

	if not is_dodging:
		return

	# mantener velocidad constante 
	owner.velocity.x = dodge_direction.x * dodge_speed
	owner.velocity.z = dodge_direction.z * dodge_speed


func _on_dodge_timer_timeout() -> void:
	is_dodging = false
	pass
