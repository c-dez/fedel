extends Camera3D


@onready var spring_pos: Node3D = %SpringPos

@export var lerp_power: float = 1.0


func _process(delta: float) -> void:
	position = lerp(
		position,
		spring_pos.position,
		delta * lerp_power
	)
	pass
