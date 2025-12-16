extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	animated_sprite_2d.play("rotating")
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("activar_super_luz"):
		
		# Ejecutamos la función en el personaje
		body.activar_super_luz()
		body.plus1Diamante()
		print("¡Diamante recogido! Efecto activado.")
		AudioManager.pick_diamond()
			
		# Borramos el diamante
		queue_free()


# Configuración de capas
const CAPA_PRINCIPAL = 1  # La capa donde el jugador lo puede tocar
const CAPA_LIMBO = 20     # La "otra capa" donde lo escondemos

func activar():
	visible = true
	visible = true
	# "disabled" en false significa que ESTÁ ACTIVO
	# Usamos set_deferred para esperar al siguiente frame seguro de física
	collision_shape_2d.set_deferred("disabled", false)
	print("✨ Objeto visible y colisión ACTIVADA")

func desactivar():
	visible = false
	# "disabled" en true significa que ESTÁ APAGADO
	collision_shape_2d.set_deferred("disabled", true)
	print("👻 Objeto oculto y colisión APAGADA")
