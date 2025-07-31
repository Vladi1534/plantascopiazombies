class_name PlantaGeneracion
extends PlantaBasica

# Estadisticas
@export var cantidad_de_soles : float = 25
@export var tiempo_de_generacion : float = 3
# Referencias
@onready var timer: Timer = $Timer
@export var escena_sol : PackedScene

func _ready():
	ini_planta()
	# Configurar Timer
	timer.wait_time = tiempo_de_generacion
	timer.timeout.connect(generar_soles)
	
	# Iniciar Temporizador
	timer.start()

func generar_soles():
	pass
	
	# Validar escena del sol
	
	if escena_sol != null:
		# Creamos una instancia de la escena
		var nuevo_sol : Sol = escena_sol.instantiate()
		nuevo_sol.cantidad_soles = cantidad_de_soles
		# Agregamos la instancia al juego
		get_tree().current_scene.add_child(nuevo_sol)
		# Le asignamos la ubicacion
		var posicion_aleatoria = randf_range(-12, 12)
		nuevo_sol.global_position = self.global_position
		nuevo_sol.global_position.x += posicion_aleatoria
	
	
	
	
