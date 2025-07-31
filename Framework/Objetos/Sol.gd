class_name Sol
extends Area2D

var cantidad_soles := 25

func _ready():
	$AnimatedSprite2D.play("default")
	$AnimationPlayer.play("start")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click_izquierdo"):
		#Agregar soles al jugador
		
		Global.agregar_soles(cantidad_soles)
		# Destruir el objeto
		queue_free()
	
