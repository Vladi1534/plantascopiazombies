class_name PlantaGeneracion
extends PlantaBasica

@export var cantidad_de_soles: int = 25
@export var tiempo_de_generacion: float = 8.0
@onready var timer: Timer = $Timer
@export var escena_sol: PackedScene

func _ready():
	ini_planta()
	timer.wait_time = tiempo_de_generacion
	timer.timeout.connect(generar_soles)
	timer.start()

func generar_soles():
	if escena_sol == null: return
	
	var nuevo_sol: Sol = escena_sol.instantiate()
	nuevo_sol.cantidad_soles = cantidad_de_soles
	
	# Solución al error "Node not found": Añadir el sol de forma segura.
	# Asegúrate de haber creado un nodo llamado "Soles" en tu escena del mundo.
	var contenedor_soles = GameManager.mundo_actual.get_node_or_null("Soles")
	if contenedor_soles:
		contenedor_soles.call_deferred("add_child", nuevo_sol)
	else:
		get_tree().root.call_deferred("add_child", nuevo_sol)

	var posicion_aleatoria = randf_range(-12, 12)
	nuevo_sol.global_position = self.global_position
	nuevo_sol.global_position.x += posicion_aleatoria
	
	
	
