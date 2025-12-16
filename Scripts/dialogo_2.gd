extends Node2D
const DIALOGO_ROBIN = preload("res://dialogues/prueba.dialogue")
func _process(delta: float) -> void:
	
	if G.changed:
		var body=get_tree().get_first_node_in_group("character")
		aplicar_luz(body)
		body.dialogoinicialacabado()
		set_process(false)
func dialogoPrincipal(body: CharacterBody2D) -> void:
	DialogueManager.show_dialogue_balloon(
		DIALOGO_ROBIN,
		"start",
		[]
	)
	aplicar_luz(body)

func aplicar_luz(character: CharacterBody2D) -> void:
	print(str(G.light_level)+"AQUIIIIII")
	print("💡 Luz desde GameState:", G.light_level)
	character.set_light(G.light_level)
