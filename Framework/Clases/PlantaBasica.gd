class_name PlantaBasica
extends Node2D
# Estadisticas de la planta
var vida : float = 100.0
@export var vida_maxima : float = 100.0

@export var celda_ocupada : Vector2

# Animaciones
@export var animacion : AnimationPlayer
@export var animacion_impacto : AnimationPlayer

func ini_planta():
	vida = vida_maxima
	
	if animacion != null:
		if animacion.has_animation("reposo"):
			animacion.play("reposo")

func recibir_ataque(cantidad : float):
	vida -= cantidad
	
	if vida <= 0:
		queue_free()
		return
	
	animacion_impacto.play("impacto")
