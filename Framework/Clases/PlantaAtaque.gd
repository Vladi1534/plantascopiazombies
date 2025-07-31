class_name PlantaAtaque
extends PlantaBasica

# Estadisticas

@export var daño_por_disparo : float = 25
@export var tiempo_de_disparo : float = 1.0
 
# Disparo

var zombie_al_alcance := true
@export var bala_instancia : PackedScene


@onready var timer: Timer = $Timer
@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	ini_planta()
	timer.wait_time = tiempo_de_disparo
	timer.timeout.connect(disparar)
	
	timer.start()

func disparar():
	# Validar si la planta puede disparar
	if zombie_al_alcance:
		animation_player.play("shoot", -1, 0.5, false)

func iniciar_bala():
	var bala : Bala = bala_instancia.instantiate()
	get_tree().current_scene.add_child(bala)
	bala.global_position = marker_2d.global_position


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		animation_player.play("reposo")
