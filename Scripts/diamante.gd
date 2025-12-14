extends Area2D

func _on_body_entered(body) -> void:
	if body.has_method("activar_super_luz"):
		
		# Ejecutamos la función en el personaje
		body.activar_super_luz()
		body.plus1Diamante()
		print("¡Diamante recogido! Efecto activado.")
			
		# Borramos el diamante
		queue_free()
