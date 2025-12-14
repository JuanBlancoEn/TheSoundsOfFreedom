extends RigidBody2D

# Asegúrate de poner aquí el nombre correcto de tu nodo de imagen
# En tu captura anterior se llamaba "sprite_onda" o "AnimatedSprite2D"
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta):
	# Si la bala se mueve...
	if linear_velocity.length_squared() > 1.0:
		# NO usamos 'rotation = ...' porque eso rota el cuerpo físico.
		# Rotamos solo la IMAGEN para que apunte hacia donde vamos.
		# Usamos 'global_rotation' para ignorar la rotación del padre.
		sprite_2d.global_rotation = linear_velocity.angle()
