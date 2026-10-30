extends Node3D

@onready var spring_arm: SpringArm3D = $SpringArm3D


@export var mouse_sens: float = 0.001
## Sensibilidad del joystick
@export var joy_sens: float = 2.0
@export var joy_dead_zone: float = 0.1

@export_range(-90.0, 0.0, 0.1, 'radians_as_degrees') var min_vertical_angle: float = - PI / 2

@export_range(0.0, 90.0, 0.1, 'radians_as_degrees') var max_vertical_angle: float = PI / 4

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	# movimiento camara con mouse
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sens
		rotation.y = wrapf(rotation.y, 0.0, TAU)

		rotation.x -= event.relative.y * mouse_sens
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)


func _process(delta: float) -> void:
	# Joystick derecho: movimiento horizontal y vertical
	var joy_x: float = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var joy_y: float = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(joy_x) < joy_dead_zone:
		joy_x = 0.0

	if abs(joy_y) < joy_dead_zone:
		joy_y = 0.0

	rotation.y -= joy_x * joy_sens * delta
	rotation.y = wrapf(rotation.y, 0.0, TAU)

	rotation.x -= joy_y * joy_sens * delta
	rotation.x = clamp(
		rotation.x,
		min_vertical_angle,
		max_vertical_angle
	)