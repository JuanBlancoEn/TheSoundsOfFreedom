extends Node2D

@onready var valla_objetivo = $fences1
@onready var character: CharacterBody2D = $Character
@onready var label_fence1: Label = $Label



func _process(delta):
	# Si no encontramos al personaje, no hacemos nada para evitar errores
	
	# 2. Leemos la variable del personaje (sincronización constante)
	var diamantes_actuales = character.diamantes
	label_fence1.text="UNLOCK IT WITH 11 DIAMONDS \n         YOU HAVE "+str(diamantes_actuales)
	# 3. Comprobamos si llegó a la meta
	if diamantes_actuales >= 11:
		
		# Verificamos si la valla aún existe antes de intentar borrarla
		if is_instance_valid(valla_objetivo):
			valla_objetivo.queue_free()
			print("¡Meta cumplida! Valla eliminada.")
			label_fence1.queue_free()
			# Opcional: Dejamos de ejecutar _process para ahorrar recursos
			set_process(false)
