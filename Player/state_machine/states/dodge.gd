extends State


# Dodge state
var dodge_duration: float = 0.5
@export var dodge_jump_speed: int = 5
@export var dodge_speed: float = 10.0
@onready var dodge_timer: Timer = $DodgeTimer

var is_dodging: bool = false
var last_input := Vector2.ZERO
var dodge_direction := Vector3.ZERO

func _ready() -> void:
	dodge_timer.connect('timeout', _on_dodge_timer_timeout)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('dodge'):
		request_dodge()





