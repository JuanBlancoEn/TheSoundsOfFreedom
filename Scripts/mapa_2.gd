extends Node2D

@onready var valla_objetivo = $fences1
var personaje_ref = null # Aquí guardaremos la referencia al personaje

func _ready():
	# 1. Buscamos al personaje usando el grupo "character"
	# get_nodes_in_group devuelve una lista (array), cogemos el primero [0]
	var personajes = get_tree().get_nodes_in_group("character")
	
	if personajes.size() > 0:
		personaje_ref = personajes[0]
	else:
		print("ERROR: No se encontró ningún nodo en el grupo 'character'")

func _process(delta):
	# Si no encontramos al personaje, no hacemos nada para evitar errores
	if personaje_ref == null:
		return

	# 2. Leemos la variable del personaje (sincronización constante)
	var diamantes_actuales = personaje_ref.diamantes
	
	# 3. Comprobamos si llegó a la meta
	if diamantes_actuales >= 11:
		
		# Verificamos si la valla aún existe antes de intentar borrarla
		if is_instance_valid(valla_objetivo):
			valla_objetivo.queue_free()
			print("¡Meta cumplida! Valla eliminada.")
			
			# Opcional: Dejamos de ejecutar _process para ahorrar recursos
			set_process(false)
