extends StaticBody2D

@export var luz_p2 : PackedScene
@export var personaje1: CharacterBody2D 

var can_shoot = true

func _process(delta):
	if personaje1:
		var distance = global_position.distance_to(personaje1.global_position)
		if  can_shoot:
			shoot_light()

func shoot_light():
	if luz_p2:
		var light = luz_p2.instantiate()
		
		get_parent().add_child(light)
		
		light.start(global_position, personaje1.global_position)
		
		can_shoot = false
		await get_tree().create_timer(2.0).timeout
		can_shoot = true
