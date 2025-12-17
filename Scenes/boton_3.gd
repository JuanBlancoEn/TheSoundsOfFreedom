extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if G.combinacion_botones == [0,0,0] and G.boton3 == true:
		animated_sprite_2d.play("off")
		
func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("bullet"):
			animated_sprite_2d.play("semi")
			await get_tree().create_timer(2.0).timeout
			if G.combinacion_botones == [2,1,0] :
				animated_sprite_2d.play("on")
				G.boton3 = true
				G.combinacion_botones = [2,1,3]
				G.es_comb_botones_correcta = true
			else:
				animated_sprite_2d.play("off")
				G.boton3 = false
				G.combinacion_botones = [0,0,0]
			
