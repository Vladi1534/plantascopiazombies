class_name PlantaAtaque
extends PlantaBasica

@export var escena_bala: PackedScene

@onready var temporizador_disparo: Timer = $Timer
@onready var punto_disparo: Marker2D = $Marker2D
@onready var detector_rango: Area2D = $DetectorRango

var zombies_en_rango: Array[Zombie] = []

func _ready():
	ini_planta()
	temporizador_disparo.timeout.connect(disparar)
	detector_rango.body_entered.connect(_on_DetectorRango_body_entered)
	detector_rango.body_exited.connect(_on_DetectorRango_body_exited)
	ajustar_rango_ataque()
	if animacion:
		animacion.play("reposo")

func disparar():
	if not zombies_en_rango.is_empty():
		if animacion:
			animacion.play("disparar")
		
		if escena_bala == null: return
			
		var nueva_bala: Bala = escena_bala.instantiate()
		
		# Añade la bala de forma segura usando call_deferred.
		if GameManager.proyectiles_container != null:
			GameManager.proyectiles_container.call_deferred("add_child", nueva_bala)
		else:
			get_tree().root.call_deferred("add_child", nueva_bala)
		
		nueva_bala.global_position = punto_disparo.global_position
		nueva_bala.setup(Vector2.RIGHT)

func ajustar_rango_ataque():
	var nodos_limite = get_tree().get_nodes_in_group("limite_jardin")
	if nodos_limite.is_empty(): return
	
	var limite_jardin = nodos_limite[0]
	var limite_x = limite_jardin.global_position.x
	var inicio_x = punto_disparo.global_position.x
	var largo_rango = limite_x - inicio_x
	
	if largo_rango < 0: largo_rango = 0
	
	var shape: RectangleShape2D = detector_rango.get_node("CollisionShape2D").shape
	shape.size.x = largo_rango
	detector_rango.get_node("CollisionShape2D").position.x = largo_rango / 2.0

func _on_DetectorRango_body_entered(body: Node2D):
	if body is Zombie and not zombies_en_rango.has(body):
		zombies_en_rango.append(body)
		if temporizador_disparo.is_stopped():
			disparar()
			temporizador_disparo.start()

func _on_DetectorRango_body_exited(body: Node2D):
	if body is Zombie and zombies_en_rango.has(body):
		zombies_en_rango.erase(body)
		if zombies_en_rango.is_empty():
			temporizador_disparo.stop()
			if animacion:
				animacion.play("reposo")
