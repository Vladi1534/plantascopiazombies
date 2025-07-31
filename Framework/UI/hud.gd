class_name HUD
extends Control

@onready var cantidad_soles = $PanelSoles/HBoxContainer/MarginContainer/Label

func _ready():
	Global.soles_actualizados.connect(actualizar_soles)
	GameManager.hud = self
	activar_boton_cancelar(false)

func actualizar_soles(soles : int):
	cantidad_soles.text = str(soles)
	
	
func _on_b_cancel_button_down() -> void:
	GameManager.cancelar_planta()

func activar_boton_cancelar(valor : bool):
	$B_Cancel.visible = valor
