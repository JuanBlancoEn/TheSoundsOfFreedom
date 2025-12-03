extends Area2D

func _on_body_entered(body) -> void:
	if body is CharacterBody2D:
		
		# 2. Buscamos el nodo "PointLight2D" dentro del personaje
		var luz = body.get_node_or_null("PointLight2D")
		
		# Si encontramos la luz, aplicamos el cambio
		if luz:
			# Opción A: Aumentar la escala del nodo (Transform)
			luz.scale *= 1.25 
			
			# Opción B: Si la luz se ve pixelada o rara, usa esta línea en su lugar:
			# luz.texture_scale *= 1.25
			
			print("¡Luz aumentada! Nueva escala: ", luz.scale)
			
		# 3. Hacemos desaparecer el diamante
		queue_free()
