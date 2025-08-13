# game_manager.gd (CORREGIDO Y MEJORADO)
extends Node2D

var proyectiles_container: Node2D
#-------------------------------------------------
# SECCIÓN DE PLANTAS Y CURSOR
#-------------------------------------------------
var cursor_planta: CursorPlanta
var panel_planta_actual: PanelPlanta
var celda_actual: Node
var posicion_celda_actual: Vector2i
var plantas_colocadas: Dictionary = {}

var mostrar_cursor_planta: bool = false:
	set(valor):
		mostrar_cursor_planta = valor
		if cursor_planta != null:
			cursor_planta.visible = valor
		if mundo_actual != null:
			mundo_actual.mostrar_celdas(valor)
		if hud != null:
			hud.activar_boton_cancelar(valor)

#-------------------------------------------------
# SECCIÓN DE REFERENCIAS (HUD, MUNDO)
#-------------------------------------------------
var mundo_actual: Mundo
var hud: HUD

#-------------------------------------------------
# SECCIÓN DE OLEADAS DE ZOMBIES
#-------------------------------------------------
@export var oleadas: Array[Dictionary] = [
	{
		"nombre": "Oleada 1",
		"retraso_inicial": 5.0,
		"zombies": [{"tipo": preload("res://Framework/Clases/Zombies/zombie.tscn"), "cantidad": 3}],
		"intervalo_spawn": Vector2(3.0, 5.0) # Spawnear un zombi cada 3 a 5 segundos
	},
	{
		"nombre": "Oleada 2",
		"retraso_inicial": 10.0,
		"zombies": [{"tipo": preload("res://Framework/Clases/Zombies/zombie.tscn"), "cantidad": 5}],
		"intervalo_spawn": Vector2(2.0, 4.0)
	}
]

var oleada_actual_idx: int = -1
var zombies_por_spawnear: Array = []
@onready var temporizador_oleada: Timer = $TemporizadorOleada # Asegúrate de tener este Timer como hijo

#-------------------------------------------------
# FUNCIONES PRINCIPALES
#-------------------------------------------------

func _physics_process(_delta):
	# Primero comprobamos que el cursor deba mostrarse
	# Y SEGUNDO (y más importante) que la variable cursor_planta NO SEA NULA.
	if mostrar_cursor_planta and cursor_planta != null:
		cursor_planta.global_position = get_global_mouse_position()

#-------------------------------------------------
# LÓGICA DE MANEJO DE PLANTAS
#-------------------------------------------------

func planta_seleccionada(panel_planta: PanelPlanta):
	# ¡NUEVA LÍNEA DE SEGURIDAD!
	# Si por alguna razón no tenemos cursor, no continuamos.
	if cursor_planta == null:
		print("Error Crítico: La referencia a CursorPlanta no se estableció en GameManager.")
		return
		
	if Global.soles < panel_planta.precio_soles:
		print("No tienes suficientes soles.")
		return
	
	panel_planta_actual = panel_planta
	# Ahora esta línea es segura porque ya comprobamos que cursor_planta no es nulo.
	cursor_planta.actualizar_visuales(panel_planta)
	mostrar_cursor_planta = true

func actualizar_celda_actual(pos: Vector2i, celda: Node):
	posicion_celda_actual = pos
	celda_actual = celda
	# La celda es válida si no hay una planta ya colocada
	var es_valida = not plantas_colocadas.has(pos)
	cursor_planta.establecer_celda_valida(es_valida)

func intentar_colocar_planta():
	# Solo colocar si tenemos una planta seleccionada y la celda es válida
	if panel_planta_actual and celda_actual and not plantas_colocadas.has(posicion_celda_actual):
		var nueva_planta = panel_planta_actual.planta_a_colocar.instantiate()
		
		# Usamos el contenedor "Plantas" del mundo actual
		mundo_actual.get_node("Plantas").add_child(nueva_planta)
		nueva_planta.global_position = celda_actual.global_position
		
		plantas_colocadas[posicion_celda_actual] = nueva_planta
		Global.quitar_soles(panel_planta_actual.precio_soles)
		
		# Reiniciar estado
		cancelar_planta()

func cancelar_planta():
	panel_planta_actual = null
	celda_actual = null
	cursor_planta.actualizar_visuales(null)
	mostrar_cursor_planta = false

#-------------------------------------------------
# LÓGICA DE OLEADAS
#-------------------------------------------------

func iniciar_juego(mundo_ref: Mundo, hud_ref: HUD, proy_container: Node2D):
	mundo_actual = mundo_ref
	hud = hud_ref
	cursor_planta = mundo_actual.get_node("CursorPlanta")
	
	# --- AÑADE ESTA LÍNEA ---
	proyectiles_container = proy_container
	# -------------------------
	
	mostrar_cursor_planta = false
	plantas_colocadas.clear()
	
	oleada_actual_idx = -1
	iniciar_siguiente_oleada()

func iniciar_siguiente_oleada():
	oleada_actual_idx += 1
	if oleada_actual_idx >= oleadas.size():
		print("¡HAS GANADO! No hay más oleadas.")
		# Aquí puedes añadir lógica de victoria
		return

	var oleada = oleadas[oleada_actual_idx]
	print("Iniciando: ", oleada["nombre"])
	
	# Llenar la lista de zombies a spawnear para esta oleada
	zombies_por_spawnear.clear()
	for item in oleada["zombies"]:
		var escena_zombie = item["tipo"]
		for i in range(item["cantidad"]):
			zombies_por_spawnear.append(escena_zombie)
	
	zombies_por_spawnear.shuffle()
	
	# Empezar a llamar zombies después de un retraso inicial
	temporizador_oleada.wait_time = oleada["retraso_inicial"]
	temporizador_oleada.start()

func _on_temporizador_oleada_timeout():
	if zombies_por_spawnear.is_empty():
		# Si ya no hay zombies por spawnear, esperamos para la siguiente oleada
		# (Podrías añadir una condición para esperar a que todos los zombies mueran)
		print("Oleada completada. Preparando la siguiente.")
		iniciar_siguiente_oleada()
		return
	
	# Sacamos un zombi de la lista y lo creamos
	var proximo_zombie_escena = zombies_por_spawnear.pop_front()
	spawn_zombie(proximo_zombie_escena)
	
	# Programamos el siguiente spawn en un intervalo aleatorio
	var oleada = oleadas[oleada_actual_idx]
	var intervalo: Vector2 = oleada["intervalo_spawn"]
	temporizador_oleada.wait_time = randf_range(intervalo.x, intervalo.y)
	temporizador_oleada.start()

func spawn_zombie(escena_zombie: PackedScene):
	# Buscamos los puntos de spawn en el mundo actual
	var puntos_spawn = mundo_actual.get_node("Lineas").get_children()
	if puntos_spawn.is_empty():
		print("Error: No se encontraron puntos de spawn (Marker2D) en el nodo 'Lineas'.")
		return
	
	var nuevo_zombie = escena_zombie.instantiate()
	# Elegimos un carril al azar
	var punto_spawn = puntos_spawn.pick_random()
	
	# Añadimos el zombi al contenedor "Zombies" del mundo
	mundo_actual.get_node("Zombies").add_child(nuevo_zombie)
	nuevo_zombie.global_position = punto_spawn.global_position
