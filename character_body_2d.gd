extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var velocidad : float = 150.0

func _physics_process(delta):
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direccion:
		velocity = direccion * velocidad
		animacion(direccion)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, velocidad)
		animated_sprite_2d.play("idle")

	move_and_slide()

func animacion(dir: Vector2):
	var angulo = dir.angle()
	var index = int(round(angulo / (PI / 4)))
	index = posmod(index, 8)
	
	var anim_names = [
		"walk_right",    
		"w_down_right",  
		"walk_down",     
		"w_down_left",   
		"walk_left",    
		"w_up_left",     
		"walk_up",     
		"w_up_right"   
	]
	
	animated_sprite_2d.play(anim_names[index])
