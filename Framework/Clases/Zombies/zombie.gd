# Zombie.gd (LIGERAMENTE MEJORADO)
class_name Zombie
extends CharacterBody2D

enum {CAMINAR, COMER, ABATIDO}

var estado_actual = CAMINAR
var estado_previo

@export var salud_maxima: float = 100.0
var salud_actual: float = 100.0

@export var ataque: float = 20.0
@export var tiempo_de_ataque: float = 1.5
var planta_a_atacar: PlantaBasica

@export var velocidad: float = 15.0
var direccion: int = -1

@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var atacar_planta_timer: Timer = $AtacarPlantaTimer
@onready var animacion_impacto: AnimationPlayer = $AnimacionImpacto
@onready var detector_plantas: Area2D = $Detector

func _ready():
	salud_actual = salud_maxima
	
	atacar_planta_timer.wait_time = tiempo_de_ataque
	atacar_planta_timer.timeout.connect(atacar_planta)
	
	# Conectar señales del detector por código
	detector_plantas.area_entered.connect(_on_detector_area_entered)
	detector_plantas.area_exited.connect(_on_detector_area_exited)

func _physics_process(_delta):
	if estado_actual != estado_previo:
		match estado_actual:
			CAMINAR:
				animacion.play("caminar")
			COMER:
				animacion.play("comer")
			ABATIDO:
				animacion.play("abatido")
		estado_previo = estado_actual
		
	if estado_actual == CAMINAR:
		velocity.x = velocidad * direccion
	else:
		velocity.x = 0
	
	move_and_slide()

# La señal es "area_entered" si el detector busca otras Areas2D (como las plantas)
func _on_detector_area_entered(area: Area2D):
	if area.get_parent() is PlantaBasica:
		estado_actual = COMER
		planta_a_atacar = area.get_parent()
		atacar_planta_timer.start() # Empezar a atacar

func _on_detector_area_exited(area: Area2D):
	if area.get_parent() == planta_a_atacar:
		estado_actual = CAMINAR
		planta_a_atacar = null
		atacar_planta_timer.stop()

func atacar_planta():
	if planta_a_atacar != null and is_instance_valid(planta_a_atacar):
		planta_a_atacar.recibir_ataque(ataque)
	else:
		# La planta fue destruida, volver a caminar
		estado_actual = CAMINAR
		atacar_planta_timer.stop()

func recibir_ataque(cantidad: float):
	salud_actual -= cantidad
	animacion_impacto.play("impacto")
	
	if salud_actual <= 0 and estado_actual != ABATIDO:
		estado_actual = ABATIDO
		# Desactivar colisiones para que no bloquee a otros zombies
		$CollisionShape2D.disabled = true
		$Detector/CollisionShape2D.disabled = true
		# Esperar a que la animación de muerte termine para eliminar el nodo
		await animacion.animation_finished
		queue_free()
