extends Node3D

# TODO: es temporal esta solucion
func _physics_process(_delta: float) -> void:
	var skin: Node3D = %Skin
	rotation.y = skin.rotation.y