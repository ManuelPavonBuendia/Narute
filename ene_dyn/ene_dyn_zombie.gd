extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var anim = $ani_ene_dyn   # <-- ajusta si es otro nodo
@export var speed = 100

var sentido = 1
var muerto = false

func _ready() -> void:
	anim.play("default")

func _on_ene_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.morir()

func _physics_process(delta: float) -> void:
	if muerto:
		return
		
	velocity.y += gravity * delta

	if is_on_wall():
		sentido *= -1

	if sentido == 1:
		if $detectorDerecho.is_colliding():
			velocity.x = speed
			anim.flip_h = false
		else:
			sentido = -1

	elif sentido == -1:
		if $detectorIzquierdo.is_colliding():
			velocity.x = -speed
			anim.flip_h = true
		else:
			sentido = 1

	move_and_slide()
