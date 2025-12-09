extends CharacterBody2D

@export var velocidad: float = 80.0
@export var dano: int = 10
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Variable para saber a quién perseguir
var objetivo: Node2D = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite_2d.play("idle")

func _physics_process(delta):
	if objetivo:
		animated_sprite_2d.play("walk")
		# 1. Calcular dirección hacia el jugador
		var direccion = (objetivo.global_position - global_position).normalized()
		
		# 2. Moverse
		velocity = direccion * velocidad
		move_and_slide()
		
		# 3. Girar el sprite según la dirección
		if direccion.x > 0:
			sprite.flip_h = false # Mirar derecha
		elif direccion.x < 0:
			sprite.flip_h = true  # Mirar izquierda
			
		# Aquí podrías poner: sprite.play("run")
	else:
		# Si no hay objetivo, quieto (o podrías poner patrulla aquí)
		velocity = Vector2.ZERO
		# sprite.play("idle")

# --- SEÑALES (CONECTAR DESDE EL EDITOR) ---

# 1. Cuando alguien entra en el rango de visión (AreaDeteccion)
func _on_area_deteccion_body_entered(body):
	if body.is_in_group("Personaje"):
		objetivo = body
		print("¡Te veo!")

# 2. Cuando alguien sale del rango de visión (AreaDeteccion)
func _on_area_deteccion_body_exited(body):
	if body == objetivo:
		objetivo = null
		print("Te perdí...")

# 3. Cuando tocas al jugador para hacer daño (AreaAtaque)
func _on_area_ataque_body_entered(body):
	if body.name == "Personaje":
		if body.has_method("recibir_dano"):
			body.recibir_dano(dano)
			print("¡Toma golpe!")
