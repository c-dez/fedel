extends NormalAttackState
class_name FireballAttackState

@onready var fireball: PackedScene = preload('res://fireball/fireball.tscn') 
@onready var muzze:Node3D = %Muzzle

# func _ready() -> void:
# 	super._ready()

func attack() ->void:
	var f:FireBall = fireball.instantiate()
	muzze.add_child(f)
	f.current_target = %TargetArea.current_target
	sm.normal_attack_index += 1

