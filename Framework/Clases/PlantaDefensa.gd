class_name PlantaDefensa
extends PlantaBasica

@onready var animationPLanta: AnimationPlayer = $AnimationPlayer


@onready var animacionImpacto: AnimationPlayer = $AnimacionImpacto


@export var vida_extra : float = 100.0

func _ready():
	ini_planta()
	vida_maxima += vida_extra
	vida += vida_extra 
	
