extends Node
signal soles_actualizados(cantidad)


var soles : int = 500 

func _ready():
	await get_tree().create_timer(0.1).timeout
	soles_actualizados.emit(soles)

func agregar_soles(cantidad):
	soles += cantidad
	soles_actualizados.emit(soles)
	
func quitar_soles(cantidad):
	soles -= cantidad 
	soles_actualizados.emit(soles)
