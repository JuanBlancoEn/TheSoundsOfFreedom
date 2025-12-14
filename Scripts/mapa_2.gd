extends Node2D

@onready var valla_objetivo = $fences1
@onready var character: CharacterBody2D = $Character



func _process(delta):
	# Si no encontramos al personaje, no hacemos nada para evitar errores
	
	# 2. Leemos la variable del personaje (sincronización constante)
	var diamantes_actuales = character.diamantes
	
	# 3. Comprobamos si llegó a la meta
	if diamantes_actuales >= 11:
		
		# Verificamos si la valla aún existe antes de intentar borrarla
		if is_instance_valid(valla_objetivo):
			valla_objetivo.queue_free()
			print("¡Meta cumplida! Valla eliminada.")
			
			# Opcional: Dejamos de ejecutar _process para ahorrar recursos
			set_process(false)
