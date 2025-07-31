class_name Bala
extends Area2D

var speed : float = 100.0
const Bala_Impacto = preload("res://Framework/Objetos/Bala_impacto.tscn")

func _physics_process(delta):
	position.x += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	var targed_zombie = area.get_parent()
	
	if targed_zombie is Zombie:
		# Aparecer Bala
		var impacto = Bala_Impacto.instantiate()
		get_tree().current_scene.add_child(impacto)
		impacto.global_position = global_position
		# Aplicar el daño al zombie
		targed_zombie.recibir_ataque(25)
		# Eliminar bala
		queue_free()
