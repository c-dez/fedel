extends Node3D


@export var vision_cone_deg: int = 20
@onready var area: Area3D = $Area3D
@onready var player: Player = owner
var vision_cone:float = 0.0

var enemies: Array[Node3D] = []
var closest_enemy: Node3D = null

func _ready() -> void:
	vision_cone = cos(deg_to_rad(vision_cone_deg))

func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % 10 != 0:
		return

	enemies = area.get_overlapping_bodies()
	closest_enemy = null

	var distance: float = INF
	var forward = - player.camera.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()

	for enemy in enemies:
		var to_enemy := (
			enemy.global_position - player.global_position
		)
		to_enemy.y = 0.0
		to_enemy = to_enemy.normalized()

		var dot: float = forward.dot(to_enemy)

		if dot >= vision_cone:
			var distance_to_player := player.global_position.distance_to(
				enemy.global_position
			)

			if distance_to_player < distance:
				distance = distance_to_player
				closest_enemy = enemy
