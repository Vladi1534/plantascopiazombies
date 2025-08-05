# Archivo: PlantaAtaque.gd

class_name PlantaAtaque
extends PlantaBasica

# --- VARIABLES ---
@export var escena_bala: PackedScene

@onready var temporizador_disparo: Timer = $Timer
@onready var punto_disparo: Marker2D = $Marker2D
@onready var forma_colision: CollisionShape2D = $DetectorRango/CollisionShape2D

var zombies_en_rango: Array = []

# --- FUNCIONES DE GODOT ---
func _ready():
	# Conectamos el timer al disparo
	temporizador_disparo.timeout.connect(disparar)
	
	# Ajustamos el rango tan pronto como la planta aparece.
	ajustar_rango_ataque()
	
	# Habilitamos la detección ahora que todo está listo.
	forma_colision.disabled = false
	
	# --- NUEVA LÍNEA: INICIAMOS LA ANIMACIÓN DE REPOSO ---
	# Esto evita que la planta se quede "congelada" al ser plantada.
	animacion.play("reposo") # Asegúrate de tener una animación llamada "reposo"


# --- LÓGICA DE ATAQUE ---
func disparar():
	if not zombies_en_rango.is_empty():
		animacion.play("disparar") 
		var nueva_bala = escena_bala.instantiate()
		
		# Añadimos la bala a la escena principal
		get_tree().root.add_child(nueva_bala)
		nueva_bala.global_position = punto_disparo.global_position
		
		# --- LÍNEA MODIFICADA ---
		# Ahora la planta configura la bala directamente
		nueva_bala.iniciar(Vector2.RIGHT)

# --- FUNCIÓN PARA AJUSTAR EL RANGO ---
func ajustar_rango_ataque():
	var nodos_limite = get_tree().get_nodes_in_group("limite_jardin")
	if nodos_limite.is_empty():
		print("Error: No se encontró el nodo 'LimiteJardin' en el grupo 'limite_jardin'.")
		return
	var limite_jardin = nodos_limite[0]

	var limite_x = limite_jardin.global_position.x
	var inicio_x = punto_disparo.global_position.x
	
	var largo_rango = limite_x - inicio_x
	
	if largo_rango < 0:
		largo_rango = 0
		
	forma_colision.shape.size.y = 30 
	forma_colision.shape.size.x = largo_rango
	
	forma_colision.position.x = largo_rango / 2.0


# --- SEÑALES DEL DETECTOR ---
func _on_DetectorRango_body_entered(body: Node2D):
	if body is Zombie and not zombies_en_rango.has(body):
		zombies_en_rango.append(body)
		if temporizador_disparo.is_stopped():
			disparar()
			temporizador_disparo.start()

func _on_DetectorRango_body_exited(body: Node2D):
	if body is Zombie and zombies_en_rango.has(body):
		zombies_en_rango.erase(body)
		if zombies_en_rango.is_empty():
			temporizador_disparo.stop()
			animacion.play("reposo")
