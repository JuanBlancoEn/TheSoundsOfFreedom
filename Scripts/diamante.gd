extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("rotating")
func _on_body_entered(body) -> void:
	if body.has_method("activar_super_luz"):
		
		# Ejecutamos la función en el personaje
		body.activar_super_luz()
		body.plus1Diamante()
		print("¡Diamante recogido! Efecto activado.")
			
		# Borramos el diamante
		queue_free()
