extends AnimatedSprite2D

func _ready():
	# Conecta la señal "animation_finished" a la función "_on_animation_finished".
	# Esto asegura que la función se llame cuando la animación termine.
	animation_finished.connect(_on_animation_finished)
	
	# Inicia la animación.
	play("default")


# Esta función se ejecutará automáticamente cuando termine la animación.
func _on_animation_finished() -> void:
	# Elimina el nodo de la escena de forma segura.
	queue_free()
