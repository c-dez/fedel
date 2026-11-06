extends NormalAttackState
class_name FireballAttackState

@onready var fireball: PackedScene = preload('res://fireball/fireball.tscn') 
@onready var muzze:Node3D = %Muzzle

# func _ready() -> void:
# 	super._ready()

func attack() ->void:
	var f:FireBall = fireball.instantiate()
	muzze.add_child(f)
	f.current_target = %TargetComponent.closest_enemy
	sm.normal_attack_index += 1

	if %TargetComponent.closest_enemy == null:
		return

	var enemy = %TargetComponent.closest_enemy
	#rotate skin
	sm.player.skin.look_at(
		enemy.global_position,
		Vector3.UP
	)
	sm.player.skin.rotation.x = 0

