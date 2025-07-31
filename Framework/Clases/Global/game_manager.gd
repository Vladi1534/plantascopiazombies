extends Node2D

var mundo_actual : Mundo
var cursor_planta : CursorPlanta
var hud : HUD

var celda_valida : bool = false
var mostrar_cursor_planta : bool = false


var plantas_colocadas: Dictionary = {} 
var panel_planta_actual : PanelPlanta
var posicion_actual : Vector2i
var celda_actual : CeldaPlanta

func _physics_process(delta):
	if cursor_planta != null and mostrar_cursor_planta:
		cursor_planta.global_position = get_global_mouse_position()

func planta_seleccionada(panel_planta: PanelPlanta):
	if Global.soles < panel_planta.precio_soles:
		return
	# Actualizar la variable
	panel_planta_actual = panel_planta
	print("actualizar info del cursor")
	# Mostrar el cursor
	if mostrar_cursor_planta == false:
		print("mostrar el cursor")
		mostrar_cursor_planta = true 
		cursor_planta.actualizar_visuales(panel_planta)
		mundo_actual.mostrar_celdas(true)
		hud.activar_boton_cancelar(true)
		
		
	
func actualizar_celda_actual(pos : Vector2i, celda : CeldaPlanta):
	cursor_planta.establecer_celda_valida(!plantas_colocadas.has(pos))
	posicion_actual = pos
	celda_actual = celda
	
func intentar_colocar_planta():
	if panel_planta_actual and not plantas_colocadas.has(posicion_actual):
		# Crear una instancia de la planta a colocar
		var nueva_planta = panel_planta_actual.planta_a_colocar.instantiate()
		# Agregar la planta al nodo del mundo
		mundo_actual.plantas.add_child(nueva_planta)
		# Colocar la posicion global
		nueva_planta.global_position = celda_actual.global_position
		# Agregar la planta a mi diccionario
		plantas_colocadas[posicion_actual]= nueva_planta
		
		#Quitar los soles
		Global.quitar_soles(panel_planta_actual.precio_soles)
		#Restablecer las variables
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
