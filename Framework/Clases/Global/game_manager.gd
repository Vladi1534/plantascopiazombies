# Archivo: game_manager.gd

extends Node2D

# --- VARIABLES EXISTENTES ---
var mundo_actual : Node
var cursor_planta : CursorPlanta
var hud : Node
var celda_valida : bool = false
var mostrar_cursor_planta : bool = false
var plantas_colocadas: Dictionary = {} 
var panel_planta_actual : PanelPlanta
var posicion_actual : Vector2i
var celda_actual : Node

# --- NUEVAS VARIABLES PARA LAS OLEADAS ---
@export var oleadas: Array[Dictionary] = [
	{
		"nombre": "Oleada 1: Unos pocos zombis",
		"retraso_inicial": 5.0, # Segundos antes de que empiece esta oleada
		"zombies": [
			{"tipo": preload("res://Framework/Clases/Zombies/zombie.tscn"), "cantidad": 3}
		]
	},
	{
		"nombre": "Oleada 2: Un poco más",
		"retraso_inicial": 15.0, # Tiempo desde que acaba la anterior
		"zombies": [
			{"tipo": preload("res://Framework/Clases/Zombies/zombie.tscn"), "cantidad": 5}
		]
	}
]

var oleada_actual_idx: int = -1
var zombies_por_spawnear: Array = []
@onready var temporizador_oleada: Timer = $TemporizadorOleada # Asegúrate de tener este Timer como hijo del GameManager


# --- FUNCIONES EXISTENTES (SIN CAMBIOS) ---
func _physics_process(delta):
	if cursor_planta != null and mostrar_cursor_planta:
		cursor_planta.global_position = get_global_mouse_position()

func planta_seleccionada(panel_planta: PanelPlanta):
	if Global.soles < panel_planta.precio_soles:
		return
	panel_planta_actual = panel_planta
	if mostrar_cursor_planta == false:
		mostrar_cursor_planta = true 
		cursor_planta.actualizar_visuales(panel_planta)
		mundo_actual.mostrar_celdas(true)
		hud.activar_boton_cancelar(true)
		
func actualizar_celda_actual(pos : Vector2i, celda : Node):
	cursor_planta.establecer_celda_valida(!plantas_colocadas.has(pos))
	posicion_actual = pos
	celda_actual = celda
	
func intentar_colocar_planta():
	if panel_planta_actual and not plantas_colocadas.has(posicion_actual):
		var nueva_planta = panel_planta_actual.planta_a_colocar.instantiate()
		mundo_actual.get_node("Plantas").add_child(nueva_planta)
		nueva_planta.global_position = celda_actual.global_position
		plantas_colocadas[posicion_actual]= nueva_planta
		Global.quitar_soles(panel_planta_actual.precio_soles)
		panel_planta_actual = null
		celda_actual = null
		mostrar_cursor_planta = false
		mundo_actual.mostrar_celdas(false)
		cursor_planta.actualizar_visuales(null)
		hud.activar_boton_cancelar(false)
		
func cancelar_planta():
	panel_planta_actual = null
	celda_actual = null
	mostrar_cursor_planta = false
	mundo_actual.mostrar_celdas(false)
	cursor_planta.actualizar_visuales(null)
	hud.activar_boton_cancelar(false)


# --- NUEVAS FUNCIONES PARA LAS OLEADAS ---

func iniciar_oleadas():
	oleada_actual_idx = -1
	iniciar_siguiente_oleada()

func iniciar_siguiente_oleada():
	print("3. GameManager: Iniciando siguiente oleada.")
	oleada_actual_idx += 1
	if oleada_actual_idx >= oleadas.size():
		print("¡HAS GANADO! No hay más oleadas.")
		return
		
	var oleada_actual = oleadas[oleada_actual_idx]
	zombies_por_spawnear.clear()
	for item in oleada_actual["zombies"]:
		var escena_zombie = item["tipo"]
		var cantidad = item["cantidad"]
		for i in range(cantidad):
			zombies_por_spawnear.append(escena_zombie)
	
	zombies_por_spawnear.shuffle()
	
	temporizador_oleada.wait_time = oleada_actual["retraso_inicial"]
	temporizador_oleada.start()
	print("Próxima oleada: ", oleada_actual["nombre"])

func spawn_zombie(escena_zombie: PackedScene):
	# ADAPTACIÓN: Buscamos los Marker2D dentro de tu nodo "Lineas"
	var puntos_spawn = mundo_actual.get_node("Lineas").get_children()
	if puntos_spawn.is_empty():
		print("Error: No se encontraron Marker2D en el nodo 'Lineas'.")
		return
		
	var nuevo_zombie = escena_zombie.instantiate()
	var carril_aleatorio = randi() % puntos_spawn.size()
	var punto_spawn = puntos_spawn[carril_aleatorio]
	
	# ADAPTACIÓN: Añadimos el zombi al contenedor "Zombies"
	mundo_actual.get_node("Zombies").add_child(nuevo_zombie)
	nuevo_zombie.global_position = punto_spawn.global_position

func _on_temporizador_oleada_timeout():
	print("4. GameManager: Temporizador de oleada agotado.")
	if zombies_por_spawnear.is_empty():
		iniciar_siguiente_oleada()
		return
		
	var proximo_zombie = zombies_por_spawnear.pop_front()
	spawn_zombie(proximo_zombie)
	
	temporizador_oleada.wait_time = randf_range(2.0, 5.0)
	temporizador_oleada.start()
