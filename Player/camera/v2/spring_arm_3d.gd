extends SpringArm3D


@onready var player:Player= owner
@onready var max_rad := deg_to_rad(50)
@onready var min_rad := deg_to_rad(-70)
var mouse_sens = 00.1

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
					
