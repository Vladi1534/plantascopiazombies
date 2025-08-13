# Archivo: mundo_01.gd

extends Mundo

# Asegúrate de que los nombres de los nodos coincidan con tu escena

@onready var proyectiles_referencia: Node2D = $Proyectiles
@onready var hud_referencia: HUD = $CanvasLayer/HUD

func _ready():
	crear_celdas()
	mostrar_celdas(false)
	
	# ESTA ES LA LÍNEA QUE HAY QUE CORREGIR
	# Asegúrate de que se están pasando los TRES argumentos:
	# 1. self (el mundo)
	# 2. hud_referencia (la interfaz)
	# 3. proyectiles_referencia (el contenedor de balas)
	GameManager.iniciar_juego(self, hud_referencia, proyectiles_referencia)

func crear_celdas():
	var celda_paquete := load("res://Framework/Clases/celda_planta.tscn")
	for c in celdas.get_children():
		c.queue_free()
		
	for x in range(0, 9):
		for y in range(0, 5):
			var nueva_celda: CeldaPlanta = celda_paquete.instantiate()
			celdas.add_child(nueva_celda)
			nueva_celda.position = Vector2(15, 17.5) + (Vector2(x, y) * Vector2(30 * 1.05, 35 * 1.09))
			nueva_celda.posicion_celda = Vector2i(x, y)
