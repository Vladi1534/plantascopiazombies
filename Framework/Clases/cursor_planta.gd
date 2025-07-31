class_name CursorPlanta
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D


func actualizar_visuales(panel_planta : PanelPlanta):
	if panel_planta == null:
		sprite.texture = null
		return
	sprite.texture = panel_planta.textura
	
func establecer_celda_valida(valor : bool):
	if valor:
		sprite.self_modulate = Color(1.0, 1.0, 1.0, 0.502)
	else:
		sprite.self_modulate = Color(1.0, 0.18, 0.133, 0.502)
