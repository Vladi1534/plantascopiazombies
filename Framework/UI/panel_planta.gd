class_name PanelPlanta
extends Panel

@export var textura : Texture2D
@export var tiempo_de_recuperacion : float = 2.0
@export var precio_soles : int = 50 
@export var planta_a_colocar : PackedScene

func _ready():
	# configurar parametros iniciales
	$TextureRect.texture = textura
	$Label.text = str(precio_soles)
	# configurar temporizador
	$Timer.wait_time = tiempo_de_recuperacion
	$Timer.one_shot = true


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		GameManager.planta_seleccionada(self)
