class_name Zombie
extends CharacterBody2D

# Estados
enum {CAMINAR, COMER, ABATIDO}

var estado_actual = CAMINAR
var estado_previo 

# Estadisticas de salud
@export var salud_maxima : float = 100.0
var salud_actual : float = 100.0

# Estadisticas de ataque
@export var ataque : float = 20.0
@export var tiempo_de_ataque : float = 1.5
var planta_a_atacar : PlantaBasica

# Movimiento
@export var velocidad : float = 15.0
var direccion := -1

@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var atacar_planta_timer: Timer = $AtacarPlantaTimer
@onready var animacion_impacto: AnimationPlayer = $AnimacionImpacto


func _ready():
	atacar_planta_timer.wait_time = tiempo_de_ataque
	atacar_planta_timer.connect("timeout", atacar_planta)
	
	# Establecer salud actual
	salud_actual = salud_maxima
	

func _physics_process(delta):
	# validar si el estado ha cambiado
	if estado_actual != estado_previo:
		match estado_actual:
			CAMINAR:
				animacion.play("caminar")
			COMER:
				animacion.play("comer")
				
			ABATIDO:
				animacion.play("abatido")
					
		estado_previo = estado_actual
		
	# Poner la velocidad	
	if estado_actual == CAMINAR:
		velocity.x = velocidad * direccion
	else:
		velocity.x = 0
	
	move_and_slide()


func _on_detector_area_entered(area: Area2D) -> void:
	estado_actual = COMER
	planta_a_atacar = area.get_parent()
	atacar_planta()

func _on_detector_area_exited(area: Area2D) -> void:
	estado_actual = CAMINAR
	planta_a_atacar = null
	atacar_planta_timer.stop()

func atacar_planta():
	# verificar si la planta es valida
	if planta_a_atacar != null:
		planta_a_atacar.recibir_ataque(ataque)
		atacar_planta_timer.start()
	
func recibir_ataque(cantidad : float):
	salud_actual -= cantidad
	
	# Validar si tiene vida
	if salud_actual <= 0:
		queue_free()
		return
	animacion_impacto.play("impacto")
