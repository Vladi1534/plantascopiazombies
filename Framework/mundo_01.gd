
extends Mundo

@onready var celdas: Node2D = $Celdas
@onready var cursor_planta: Node2D = $CursorPlanta
@onready var plantas: Node2D = $Plantas


func _ready():
	#Establecer las variables del GameManager
	GameManager.mundo_actual = self
	GameManager.cursor_planta = $CursorPlanta
	
	# Crear Celdas
	crear_celdas()
	celdas.visible = false
	
	# Inicializar clase
	inicializar_mundo()

func mostrar_celdas(valor: bool):
	celdas.visible = valor	

func crear_celdas():
	var celda_paquete := load("res://Framework/Clases/celda_planta.tscn")
	for x in range(0,9):
		for y in range(0,5):
			var nueva_celda = celda_paquete.instantiate()
			celdas.add_child(nueva_celda)
			nueva_celda.position = Vector2(15,17.5)+(Vector2(x,y) * Vector2(30*1.05,35*1.09))
			nueva_celda.posicion_celda = Vector2i(x,y)
