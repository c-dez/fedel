extends Node3D


@export var spring_arm_pivot: Node3D
var targets_list: Array[Node3D] = []
var current_target: Node3D = null
@onready var area: Area3D = $Area3D


var targeting: bool = false

func _ready() -> void:
	area.connect('body_entered', on_body_entered)
	area.connect('body_exited', on_body_exited)


func _process(_delta: float) -> void:
	rotation.y = spring_arm_pivot.rotation.y
	set_current_target()

## Toggle de target lock
func set_current_target() -> void:
	# targeting = true
	if Input.is_action_just_pressed('targeting'):
		if targets_list.is_empty():
			current_target = null
			targeting = false
			return

		if current_target:
			targeting = false
			current_target = null
			return

		var nearest: Node3D = null
		var min_distance := INF

		for target in targets_list:
			var distance = owner.global_position.distance_to(target.global_position)

			if distance < min_distance:
				min_distance = distance
				nearest = target

		current_target = nearest
		targeting = true


func on_body_entered(body: Node3D) -> void:
	if body.is_in_group('enemy'):
		targets_list.append(body)


func on_body_exited(body: Node3D) -> void:
	if body.is_in_group('enemy'):
		for i in range(targets_list.size() - 1, -1, -1):
			if targets_list[i] == body:
				targets_list.remove_at(i)
