extends CharacterBody3D
class_name Player

## Clase que controla el comportamiento del jugador en el juego 3D.
## Proporciona funcionalidades para el movimiento, salto, gravedad y rotación del personaje.
@export_category('Movement')
@export var max_speed: float = 10.0
@export var acceleration: float = 50.0

@export_category('jump')
@export var jump_height: float = 2.0
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descend: float = 0.3
# gravity fields
var _jump_velocity: float
var _jump_gravity: float
var _jump_fall_gravity: float

@onready var camera = %ThirdPersonCamera
@onready var skin: Node3D = %Skin



func _ready() -> void:
	_calculate_gravity()


func _physics_process(delta: float) -> void:
	gravity(delta)
	move_and_slide()


func get_input() -> Vector2:
	var input := Input.get_vector(
		'left', 'right',
		'up', 'down'
	)
	return input


func gravity(delta: float) -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			velocity.y -= _jump_fall_gravity * delta

		else:
			velocity.y -= _jump_gravity * delta


func rotate_skin_towards_move_direction(direction: Vector3, weight: float, delta: float) -> void:
	var target_angle := atan2(direction.x, direction.z) + PI
	skin.rotation.y = lerp_angle(
		skin.rotation.y,
		target_angle,
		delta * weight
	)


func _calculate_gravity() -> void:
	_jump_velocity = 2.0 * jump_height / jump_time_to_peak
	_jump_gravity = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
	_jump_fall_gravity = 2.0 * jump_height / (jump_time_to_descend * jump_time_to_descend)