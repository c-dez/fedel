extends CharacterBody3D
class_name Player

## jump(),move(), gravity(), move_and_slide()

@export_category('Movement')
@export var max_speed: float = 10.0
@export var acceleration: float = 50.0

@export_category('jump')
@export var jump_height: float = 2.0
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descend: float = 0.3
# gravity vars
var _jump_velocity: float
var _jump_gravity: float
var _jump_fall_gravity: float

@onready var camera = %ThirdPersonCamera
@onready var skin: Node3D = %Skin

func _ready() -> void:
	calculate_gravity()


func _physics_process(delta: float) -> void:
	# move( delta)
	jump()
	gravity(delta)
	move_and_slide()

	
	
func jump() -> void:
	if is_on_floor():
		if Input.is_action_just_pressed('jump'):
			velocity.y = _jump_velocity

			
func get_input() ->Vector2:
	var input := Input.get_vector(
		'left', 'right',
		'up', 'down'
	)
	return input	
# sin uso
func move(delta: float) -> void:
	var input = get_input()
	
	var direction := (transform.basis * Vector3(input.x, 0.0, input.y)).normalized()

	# Rotates toward camera
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)

	if direction.length() > 0.0:
		var target_velocity := direction * max_speed
		
		velocity.x = move_toward(velocity.x, target_velocity.x, delta * acceleration)
		velocity.z = move_toward(velocity.z, target_velocity.z, delta * acceleration)

		rotate_skin_towards_move_direction(direction, 10.0, delta)

	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)
		velocity.z = move_toward(velocity.z, 0, delta * acceleration)


func gravity(delta: float) -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			velocity.y -= _jump_fall_gravity * delta

		else:
			velocity.y -= _jump_gravity * delta


func calculate_gravity() -> void:
	_jump_velocity = 2.0 * jump_height / jump_time_to_peak
	_jump_gravity = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
	_jump_fall_gravity = 2.0 * jump_height / (jump_time_to_descend * jump_time_to_descend)


func rotate_skin_towards_move_direction(direction: Vector3, weight: float, delta: float) -> void:
	var target_angle := atan2(direction.x, direction.z) + PI
	skin.rotation.y = lerp_angle(
		skin.rotation.y,
		target_angle,
		delta * weight
	)
