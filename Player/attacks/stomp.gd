extends Node


var stomp_duration: float = 0.5
var stomp_cancel_duration: float = 2.0
var input: Vector2 = Vector2.ZERO
var jump_speed: float = 6.0
var speed: int = 10

@onready var stomp_timer: Timer = $StompTimer
@onready var stomp_reset_timer: Timer = $StompResetTimer

signal touch_floor


func _ready() -> void:
	stomp_reset_timer.connect('timeout', _on_stomp_reset_timer)
	connect('touch_floor', _on_touch_floor)


func _physics_process(_delta: float) -> void:
	stomp()

func request_stomp() -> void:
	if not owner.is_on_floor(): # para evitar bug si se spamea stopm y dodge se puede mantener en el aire
		return
	stomp_reset_timer.stop()
	stomp_timer.start(stomp_duration)
	input = Input.get_vector(
		'left', 'right',
		'up', 'down'
	)
	owner.velocity.y = jump_speed


func stomp() -> void:
	var direction := Vector3(input.x, 0.0, input.y).normalized()
	direction = direction.rotated(Vector3.UP, owner.camera.global_rotation.y)
	if stomp_timer.time_left > 0.0:
		owner.velocity.x = direction.x * speed
		owner.velocity.z = direction.z * speed

		if owner.is_on_floor():
			touch_floor.emit()


func _on_touch_floor() -> void:
	stomp_reset_timer.start(stomp_cancel_duration)


func _on_stomp_reset_timer() -> void:
	# owner.attack_manager.reset_combo()
	pass
