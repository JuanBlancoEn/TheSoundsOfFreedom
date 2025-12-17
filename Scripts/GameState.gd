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
var joya = false


func addPuntuacion(num)->void:
	puntuacion+=num
func substractPuntuacion(num)->void:
	puntuacion-=num

var boton1 = false
var boton2 = false
var boton3 = false

var combinacion_botones = [0,0,0]

var es_comb_botones_correcta = false
