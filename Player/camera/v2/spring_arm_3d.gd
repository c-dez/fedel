extends SpringArm3D


@onready var player:Player= owner
@onready var max_rad := deg_to_rad(10)
@onready var min_rad := deg_to_rad(-60)
var mouse_sens = 00.1
@export var joy_dead_zone: float = 0.1
@export var joy_sens: float = 2.0



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var center := get_viewport().get_visible_rect().size / 2.0
	get_viewport().warp_mouse(center)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.relative:

			player.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))

			# rotates vertical
			rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			rotation.x = clamp(rotation.x, min_rad, max_rad)

			rotation.z = clamp(rotation.z, 0, 0)
					
func _process(delta: float) -> void:

	var joy_x := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var joy_y := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(joy_x) < joy_dead_zone:
		joy_x = 0.0

	if abs(joy_y) < joy_dead_zone:
		joy_y = 0.0

	rotate_camera(
		joy_x,
		joy_y,
		joy_sens *1
	)


func rotate_camera(x: float, y: float, sensitivity: float) -> void:

	# Rotación horizontal: Player
	player.rotate_y(deg_to_rad(-x * sensitivity))

	# Rotación vertical: SpringArm
	rotate_x(deg_to_rad(-y * sensitivity))

	rotation.x = clamp(
		rotation.x,
		min_rad,
		max_rad
	)
