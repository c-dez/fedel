class_name FireBall extends Area3D


@export var damage: int = 1
var current_target = null
func _ready() -> void:
	# connect('area_entered', _on_area_entered)
	connect('body_entered',_on_body_entered)
	top_level = true
	# print('target', current_target)
	pass


# func _on_area_entered(area: Area3D) -> void:

# 	pass

func _on_body_entered(body:Node3D)->void:
	if body.is_in_group('enemy'):
		print('firebal: ',body.name)
		# print('target ', current_target.name)

		call_deferred('queue_free')
