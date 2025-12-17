extends CanvasLayer


func _on_button_pressed() -> void:
	get_tree().paused = false
	visible=get_tree().paused


func _on_restart_pressed() -> void:
	get_tree().paused = false
	
	# 2. Limpiamos las variables globales (llamamos a la función del paso 1)
	G.reiniciar_datos()
	
	# 3. Cargamos la escena del Menú Principal (o el Nivel 1)
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
