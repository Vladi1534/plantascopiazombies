class_name Mundo
extends Node2D

# Sistema de oleadas
@export var oleada_actual : int = 0
@export var cantidad_de_oleadas : int = 5
@export var enemigos_por_oleada : Array[int]= [2]
@export var tiempo_de_oleadas : Array[int] = [3.0]

var timer_oleada : SceneTreeTimer

# Sistema de zombies
var enemigos_totales : int = 0
var enemigos_totales_oleada : int = 0
var enemigos_actuales : int = 0

@export var nodo_lineas : Node2D


func inicializar_mundo():
	#Crear el temporizador
	#timer_oleada = get_tree().create_timer(0)
	#timer_oleada.one_shot = true
	#timer_oleada.autostart = false
	#timer_oleada.wait_time = tiempo_de_oleadas[0]
	#
	## Conectar temporizador con el inicio de cada oleada
	#timer_oleada.timeout.connect(inicializar_oleada)
	#timer_oleada.start()
	
	# Calcular enemigos totales
	for enemigos in enemigos_por_oleada:
		enemigos_totales += enemigos
	
	
func inicializar_oleada():
	# Validar si hay nueva oleada
	if (oleada_actual >= cantidad_de_oleadas):
		return
	# Validar posicion en los array
	if enemigos_por_oleada.size() < oleada_actual or tiempo_de_oleadas.size() < oleada_actual:
		return
		
	# Que entren los zombies
	spawnear_enemigos(enemigos_por_oleada[oleada_actual])
	
	# Hacer que espere a la siguiente oleada
	timer_oleada.wait_time = tiempo_de_oleadas[oleada_actual]
	timer_oleada.start()

func spawnear_enemigos(total : int):
	pass 
		
func enemigo_abatido():
	enemigos_actuales -= 1
