extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	# Esto crea un temporizador invisible que espera 10 segundos y luego borra la bala
	await get_tree().create_timer(10.0).timeout
	queue_free()

func _process(delta):
	# Si la bala se mueve...
	if linear_velocity.length_squared() > 1.0:
		# NO usamos 'rotation = ...' porque eso rota el cuerpo físico.
		# Rotamos solo la IMAGEN para que apunte hacia donde vamos.
		# Usamos 'global_rotation' para ignorar la rotación del padre.
		sprite_2d.global_rotation = linear_velocity.angle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("eliminadorDeOndas"):
		queue_free()
