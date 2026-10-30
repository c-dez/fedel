extends Node3D



func _physics_process(delta: float) -> void:
	var spring = %Skin
	rotation.y = spring.rotation.y