class_name Bala
extends Area2D

@export var velocidad: float = 200.0
@export var dano: float = 25.0

var direccion: Vector2 = Vector2.RIGHT

func _ready():
	# Conexión de la señal para detectar colisiones.
	body_entered.connect(_on_body_entered)
	# Temporizador para que la bala se autodestruya si no golpea nada.
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += direccion * velocidad * delta

# Función para ser llamada por la planta que la dispara.
func setup(dir: Vector2):
	direccion = dir

func _on_body_entered(body: Node2D) -> void:
	if body is Zombie:
		body.recibir_ataque(dano)
		queue_free()
