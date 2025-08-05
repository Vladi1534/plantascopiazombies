# Archivo: Bala.gd

class_name Bala
extends Area2D

@export var velocidad: float = 200.0
@export var dano: float = 25.0

var direccion: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	global_position += direccion * velocidad * delta

func iniciar(dir: Vector2):
	direccion = dir
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body is Zombie:
		body.recibir_ataque(dano)
		queue_free()
