extends Node


var fireball: PackedScene = preload('res://fireball/fireball.tscn')


func fire_proyectile(parent:Node3D) ->void:
	var proyectile := fireball.instantiate()
	parent.add_child(proyectile)
	var current_target = parent.owner.get_node('TargetArea').current_target
	proyectile.current_target = current_target