extends TileMapLayer

func _process(delta: float) -> void:
	if not G.joya:
		enabled = true
	else:
		enabled = false
