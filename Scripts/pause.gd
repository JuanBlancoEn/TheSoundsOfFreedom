extends CanvasLayer

func _ready():
	# Aseguramos que al empezar el menú esté oculto
	$ColorRect.visible = false
	$Label.visible = false

# Usamos _input en vez de physics_process. 
# Esto funciona siempre, haya físicas o no.
func _input(event):
	if event.is_action_pressed("pausa"): # Solo cuando la bajas
		# Cambiamos el estado de pausa
		var nuevo_estado = not get_tree().paused
		get_tree().paused = nuevo_estado
		
		# Mostramos u ocultamos las cosas según el nuevo estado
		$ColorRect.visible = nuevo_estado
		$Label.visible = nuevo_estado
		
		print("Pausa cambiada a: ", nuevo_estado)
