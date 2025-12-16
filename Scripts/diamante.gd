extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

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
