extends TileMapLayer
func _ready() -> void:
	enabled = false

func _process(delta: float) -> void:
	if G.placa_activa:
		enabled = true
	else:
		enabled = false
