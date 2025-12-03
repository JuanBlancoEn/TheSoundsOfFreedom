extends Area2D

@export var speed : float = 200.0
@export var shrink_speed : float = 0.8 # Cuánto se encoge por segundo

var direction : Vector2 = Vector2.ZERO

func _process(delta):
	# 1. Movimiento constante en la dirección fijada
	position += direction * speed * delta
	
	# 2. Reducir escala (hacerse pequeño)
	# Restamos el mismo valor a X e Y para mantener la proporción
	scale -= Vector2(shrink_speed, shrink_speed) * delta
	
	# 3. Eliminar si es muy pequeño (para que no se invierta y crezca al revés)
	if scale.x <= 0.05:
		queue_free()

# Esta función la llamaremos desde el NPC para "configurar" la bala al nacer
func start(start_pos: Vector2, target_pos: Vector2):
	global_position = start_pos
	# Calculamos la dirección hacia el objetivo (Jugador)
	direction = (target_pos - start_pos).normalized()
	# Opcional: rotar la luz hacia el jugador (si la textura tiene forma direccional)
	look_at(target_pos)
