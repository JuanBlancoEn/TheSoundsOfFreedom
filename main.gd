extends Node2D
# Referencias a los nodos
@onready var player: CharacterBody2D = $Character
@onready var linea_guia: Line2D = $LineaGuia
@onready var punto_final: Marker2D = $PuntoFinal
@onready var pause: CanvasLayer = $pause

func _ready() -> void:
	G.primer_nivel=false
func _input(event):
	if event.is_action_pressed("pausa"): # Solo cuando la bajas
		
		get_tree().paused = true
		pause.visible=get_tree().paused
func _physics_process(delta: float) -> void:
	# Verificamos que los nodos existan para evitar errores
	if not is_instance_valid(player) or not is_instance_valid(linea_guia):
		return
		
	# 1. Obtenemos el ID del mapa de navegación del mundo actual
	var mapa_id = get_world_2d().navigation_map
	
	# 2. Definimos inicio (Jugador) y fin (La meta)
	var inicio = player.global_position
	var fin = punto_final.global_position
	
	# 3. Pedimos al servidor que calcule la ruta
	# map_get_path(mapa, origen, destino, optimizar)
	var puntos_ruta = NavigationServer2D.map_get_path(mapa_id, inicio, fin, true)
	
	# 4. Le damos los puntos a la línea para que se dibuje
	linea_guia.points = puntos_ruta
func _process(delta: float) -> void:
	if G.light_level==2:
		linea_guia.visible=true
	else: linea_guia.visible=false
