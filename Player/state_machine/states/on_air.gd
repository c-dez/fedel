extends State

@onready var sm: PlayerStateMachine = get_parent()
@export var max_speed: float = 12.0
@export var acceleration: float = 30.0

func enter() -> void:
	print(self.name)


func physics_process(_delta: float) -> void:
	if sm.player.is_on_floor():
		emit_signal('change_state_to', self, 'idle')

	sm.player.move(max_speed,acceleration,_delta)
