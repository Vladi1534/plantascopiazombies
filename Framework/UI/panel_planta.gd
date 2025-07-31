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
	if Input.is_action_just_pressed("click_izquierdo"):
		GameManager.planta_seleccionada(self)
