extends Node
class_name GameState

# ---- VARIABLES DE JUEGO ----
var light_level: float = 1.0
var changed=false
var placa_activa=false
var primer_nivel=true
var dialogo1=true
var dialogofinalacabado=false
var puntuacion=0

func addPuntuacion(num)->void:
	puntuacion+=num
func substractPuntuacion(num)->void:
	puntuacion-=num
