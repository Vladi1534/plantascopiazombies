# Mundo.gd (SIMPLIFICADO)
class_name Mundo
extends Node2D

@onready var celdas: Node2D = $Celdas

func mostrar_celdas(valor: bool):
	celdas.visible = valor

func crear_celdas():
	# Este método será implementado por cada nivel específico, como mundo_01.gd
	pass

func _on_zona_casa_body_entered(body: Node2D):
	# Si lo que entra en la casa es un zombi...
	if body is Zombie:
		print("¡UN ZOMBI HA LLEGADO! GAME OVER.")
		# Pausamos el juego para indicar que se ha perdido.
		get_tree().paused = true
		# Aquí podrías mostrar una pantalla de "Game Over" en el futuro.
