extends State
class_name AttackState
## Estado que gestiona la lógica de ataques y combos del jugador.

# res://docs/explicacion de attack.txt


# --- Variables de Datos ---
# Array que contiene todas las acciones de ataque definidas como hijos de este nodo
var attacks_array: Array[BasicAttack] = []

# Control de flujo para combos
var request_next_attack: bool = false # Indica si el jugador presionó ataque mientras estaba en medio de una animación
var attack_time: float = 0 ## Tiempo transcurrido desde que comenzó el ataque actual

# --- Referencias ---
@onready var player: Player = owner 
@onready var sm: StateMachine = get_parent() 

@onready var heavy_attack_state:HeavyAttackState = sm.get_node('HeavyAttack')

# --- Índices de Combos ---
var normal_attack_index: int = 0 # Índice del ataque actual en la secuencia de combo
var heavy_attack_index: int = 0  # Índice del ataque pesado (no utilizado en el script)
var max_normal_attacks_index:int = 0 # Total de ataques disponibles en el combo normal
# var combo_state:int = 0



# @onready var heavy = $HeavyAttack

func _ready() -> void:
	# Inicializa el array de ataques buscando a los hijos del nodo
	_set_attacks_array()


func _process(_delta: float) -> void:
	# Si no estamos en estado de ataque, escuchamos el input para entrar en él
	if sm.current_state != self:
		if Input.is_action_just_pressed('left_mouse'):
			if player.is_on_floor():
				# Solicita cambio al estado de ataque
				emit_signal('change_state_to', sm.current_state, 'attack')


func enter() -> void:
	# Detiene el movimiento del jugador al empezar a atacar
	player.velocity.x = 0
	player.velocity.z = 0
	
	# Inicia la primera acción del combo
	start_attack()


func process(_delta: float) -> void:
	# Detecta si el jugador intenta hacer un combo (presionar mouse durante el ataque)
	if Input.is_action_just_pressed('left_mouse'):
		request_attack()
	# if Input.is_action_just_pressed('right_mouse'):
	# 	### finisher
	# 	heavy.attack(combo_state)



func physics_process(_delta: float) -> void:
	attack_time += _delta

	# Verifica si el ataque actual terminó y si hay una petición de combo pendiente
	# Nota: Usa normal_attack_index-1 porque el índice ya fue incrementado en start_attack()
	if attack_time >= attacks_array[normal_attack_index-1].attack_duration:
		if request_next_attack:
			start_attack()

	# Revisa constantemente si debe pasar al estado de recuperación
	transition_to_recovery()
	

func request_attack() -> void:
	# Solo permite pedir el siguiente ataque si ha pasado un tiempo mínimo (evita spam instantáneo)
	if attack_time > 0.2:
		request_next_attack = true


func start_attack() -> void:
	# Si llegamos al final de la cadena de ataques, reiniciamos al primer ataque
	if normal_attack_index >= max_normal_attacks_index:
		normal_attack_index = 0
		# combo_state = 0

	attack_time = 0.0
	# Ejecuta la lógica específica del ataque actual (animación, daño, etc.)

	match normal_attack_index:
		0:
			attacks_array[normal_attack_index].attack()
			# combo_state = 1
			normal_attack_index += 1
		1:
			attacks_array[normal_attack_index].attack()
			# combo_state = 2
			normal_attack_index += 1
		2:
			attacks_array[1].attack()
			# combo_state = 3
			normal_attack_index += 1
		3:
			attacks_array[1].attack()
			normal_attack_index += 1
			
	request_next_attack = false


func _set_attacks_array() -> void:
	# Escanea los nodos hijos para llenar la lista de ataques automáticamente
	for i in range(get_child_count()):
		if get_child(i) is BasicAttack:
			var child := get_child(i)
			attacks_array.append(child)
			max_normal_attacks_index += 1

 
func transition_to_recovery() -> void:
	# Transición automática al estado de recuperación después de que termine
	# la duración del ataque base más un margen de tiempo (0.5s)
	if attack_time > attacks_array[0].attack_duration + 0.5:
		emit_signal('change_state_to', self, 'recovery')
