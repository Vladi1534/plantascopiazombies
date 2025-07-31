class_name  CeldaPlanta
extends Area2D

var posicion_celda : Vector2i

func _on_mouse_entered():
	GameManager.actualizar_celda_actual(posicion_celda, self)


func _on_mouse_exited() -> void:
	pass # Replace with function body.


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click_izquierdo"):
		GameManager.intentar_colocar_planta()
