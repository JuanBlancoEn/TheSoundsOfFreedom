extends CharacterBody2D

@export var speed: float = 100.0
@export var max_bounces: int = 3 # Límite de rebotes para que no dure para siempre

var direction: Vector2 = Vector2.RIGHT
var bounces: int = 0

func _ready():
	# Opcional: Destruir la onda después de un tiempo si no golpea nada
	await get_tree().create_timer(5.0).timeout
	queue_free()

func start(start_pos: Vector2, start_direction: Vector2):
	global_position = start_pos
	direction = start_direction.normalized()
	# Rotamos la onda para que mire en la dirección del movimiento
	rotation = direction.angle()

func _physics_process(delta):
	# Calculamos el movimiento para este frame
	var velocity_vector = direction * speed
	
	# Usamos move_and_collide para movernos. 
	# Si choca, devuelve información sobre la colisión.
	var collision_info = move_and_collide(velocity_vector * delta)
	
	if collision_info:
		# ¡Ha habido una colisión!
		
		# 1. Obtenemos la "normal" de la superficie golpeada.
		# La normal es una flecha que apunta hacia afuera de la pared.
		var normal = collision_info.get_normal()
		
		# 2. Calculamos la nueva dirección de rebote.
		# Godot tiene una función mágica para esto: bounce()
		direction = direction.bounce(normal)
		
		# 3. Actualizamos la rotación para que la onda mire en la nueva dirección.
		rotation = direction.angle()
		
		# 4. Gestionamos el contador de rebotes
		bounces += 1
		if bounces >= max_bounces:
			# Opcional: Un pequeño efecto antes de desaparecer
			# Por ejemplo, puedes cambiar el color o la escala aquí
			set_physics_process(false) # Dejar de moverse
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
			tween.tween_callback(queue_free)
