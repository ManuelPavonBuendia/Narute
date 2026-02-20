extends CharacterBody2D

# --- Variables Exportadas (Editables desde el Inspector) ---
@export var gravity_scale: float = 2.0
@export var speed: float = 500.0
@export var acceleration: float = 600.0
@export var friction: float = 1500.0
@export var jump_force: float = -800.0
@export var air_acceleration: float = 2000.0
@export var air_friction: float = 700.0
@onready var contador: Control = $CanvasLayer/Contador
var muerto: bool = false
var monedas: int = 0

# --- Referencias ---
@onready var ani_player = $ani_player

func _physics_process(delta: float) -> void:
	# Obtener el eje de movimiento (-1 para izquierda, 1 para derecha, 0 quieto)
	var input_axis = Input.get_axis("mover_izquierda", "mover_derecha")
	
	# Ejecutar funciones de lógica
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	
	# Aplicar el movimiento final
	move_and_slide()
	position.x = clamp(position.x, 0, 3400)

	
	# Actualizar animaciones
	update_animation(input_axis)

# --- Definición de Funciones ---

func apply_gravity(delta):
	if not is_on_floor():
		# get_gravity() obtiene la gravedad global del proyecto
		velocity += get_gravity() * delta * gravity_scale

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("saltar"):
			velocity.y = jump_force

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, air_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)

func update_animation(input_axis):
	if input_axis != 0:
		# Velocidad de animación según la velocidad del personaje
		ani_player.speed_scale = abs(velocity.x) / 100
		# Voltear el sprite según la dirección
		# Nota: si flip_h no funciona en ani_player, usa tu nodo Sprite2D
		if input_axis < 0:
			ani_player.flip_h = true
		else:
			ani_player.flip_h = false
		ani_player.play("run")
	elif not is_on_floor():
		ani_player.play("jump")
	else:
		ani_player.speed_scale = 1
		ani_player.play("idle")
		
func _ready() -> void:
	add_to_group("jugadores")

func add_moneda() -> void:
	monedas += 1
	if contador:
		contador.actualizar(monedas)
		
func morir():
		# desactivo las físicas
	set_physics_process(false)
	$ani_player.play("muerte")
	$audio_player.play()
	$tiempo.start()
	await $tiempo.timeout
	get_tree().reload_current_scene()
