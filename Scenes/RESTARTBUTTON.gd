extends Button


func _on_pressed() -> void:
	# 1. ¡IMPORTANTE! Quitamos la pausa si el juego estaba pausado
	get_tree().paused = false
	
	# 2. Limpiamos las variables globales (llamamos a la función del paso 1)
	G.reiniciar_datos()
	
	# 3. Cargamos la escena del Menú Principal (o el Nivel 1)
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
