extends StaticBody2D  # Cambia Node2D por StaticBody2D

# Ahora el sprite es hijo directo, así que quitamos "StaticBody2D/" de la ruta
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 

var life=3
var open:bool=false

func _ready() -> void:
	animated_sprite_2d.play("idle")

func hit(num:int)->void:
	print("¡Cofre golpeado!") # Debug
	if open: return # Si ya está abierto, no hacemos nada
	
	life-=num
	if(life>0):
		animated_sprite_2d.play("hit")
		get_tree().create_timer(0.5).timeout.connect(animated_sprite_2d.play.bind("idle"))
	else:
		open = true # Marcamos que se abrió para que no le sigan pegando
		animated_sprite_2d.play("opening")
		get_tree().create_timer(2.0).timeout.connect(animated_sprite_2d.play.bind("open"))
		var map2 = get_tree().get_first_node_in_group("map2")
		map2.openfence3()
