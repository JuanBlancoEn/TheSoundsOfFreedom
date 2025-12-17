extends Node2D

@onready var fence1 = $fences1
@onready var character: CharacterBody2D = $Character
@onready var label_fence1: Label = $label_fence1
@onready var label_fence2: Label = $label_fence2
@onready var fence2: TileMapLayer = $fences2
@onready var label_fence3: Label = $label_fence3
@onready var fence3: TileMapLayer = $fences3
@onready var dialogo: Node2D = $Dialogo
@onready var area_2d_29: Area2D = $Diamantes/Area2D29
@onready var area_2d_30: Area2D = $Diamantes/Area2D30
@onready var area_2d_31: Area2D = $Diamantes/Area2D31
@onready var area_2d_32: Area2D = $Diamantes/Area2D32
@onready var area_2d_33: Area2D = $Diamantes/Area2D33
@onready var area_2d_34: Area2D = $Diamantes/Area2D34
@onready var fence4: TileMapLayer = $fences4
@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D
@onready var linea_guia: Line2D = $LineaGuia
@onready var punto_final: Marker2D = $PuntoFinal

var posicion_real_fence4: Vector2
var fence3open=false
var killed_spiders:int=0
var killed_spiders2:int=0


func _ready() -> void:
	area_2d_29.desactivar()
	area_2d_30.desactivar()
	area_2d_31.desactivar()
	area_2d_32.desactivar()
	area_2d_33.desactivar()
	area_2d_34.desactivar()
	
	var char=character
	if G.primer_nivel:
		dialogo.dialogoPrincipal(char)
	posicion_real_fence4 = fence4.position
	
	# 2. La enviamos MUY LEJOS para que no moleste ni se vea
	fence4.position = Vector2(-10000, -10000)
func _physics_process(delta: float) -> void:
	# Verificamos que los nodos existan para evitar errores
	if not is_instance_valid(character) or not is_instance_valid(linea_guia):
		return
		
	# 1. Obtenemos el ID del mapa de navegación del mundo actual
	var mapa_id = get_world_2d().navigation_map
	
	# 2. Definimos inicio (Jugador) y fin (La meta)
	var inicio = character.global_position
	var fin = punto_final.global_position
	
	# 3. Pedimos al servidor que calcule la ruta
	# map_get_path(mapa, origen, destino, optimizar)
	var puntos_ruta = NavigationServer2D.map_get_path(mapa_id, inicio, fin, true)
	
	# 4. Le damos los puntos a la línea para que se dibuje
	linea_guia.points = puntos_ruta

func _process(delta):
	if G.light_level==2:
		linea_guia.visible=true
	else: linea_guia.visible=false
	# Si no encontramos al personaje, no hacemos nada para evitar errores
	killed_spiders=character.killed_spiders
	# 2. Leemos la variable del personaje (sincronización constante)
	var diamantes_actuales = character.diamantes
	if is_instance_valid(label_fence1):
		label_fence1.text="UNLOCK IT WITH 3 BUTTONS ON \n  "
	
	if is_instance_valid(label_fence2):
		label_fence2.text="UNLOCK IT BY KILLING 12 SPIDERS \n   YOU HAVE KILLED "+str(killed_spiders)
	if is_instance_valid(label_fence3):
		label_fence3.text="   UNLOCK IT BY\n OPENING THE CHEST"
	# 3. Comprobamos si llegó a la meta
	if G.es_comb_botones_correcta:
		
		# Verificamos si la valla aún existe antes de intentar borrarla
		if is_instance_valid(fence1):
			AudioManager.opening_fences()
			fence1.queue_free()
			print("¡Meta cumplida! Valla eliminada.")
			label_fence1.queue_free()
			label_fence2.visible=true
			# Opcional: Dejamos de ejecutar _process para ahorrar recursos
			
	
	if killed_spiders>=12:
		if is_instance_valid(fence2):
			AudioManager.opening_fences()
			fence2.queue_free()
			label_fence2.queue_free()
	if fence3open:
		if is_instance_valid(fence3):
			AudioManager.opening_fences()
			fence3.queue_free()
			label_fence3.queue_free()
			area_2d_29.activar()
			area_2d_30.activar()
			area_2d_31.activar()
			area_2d_32.activar()
			area_2d_33.activar()
			area_2d_34.activar()
			
	if killed_spiders2!=0:
		
		if killed_spiders==12:
			fence4.queue_free()
			killed_spiders=killed_spiders2
			killed_spiders2=0
	if G.dialogofinalacabado:
		get_tree().change_scene_to_file("res://Scenes/final.tscn")
func openfence3()->void:
	fence3open=true


func _on_area_final_body_entered(body: CharacterBody2D) -> void:
	# Verificamos si es el jugador (por seguridad)
	
	if body.is_in_group("character") and is_instance_valid(fence4):
		
		print("¡Trampa activada! Aparece la valla.")
		
		# 3. La traemos de vuelta a su sitio original INSTANTÁNEAMENTE
		fence4.position = posicion_real_fence4
		killed_spiders2=killed_spiders
		body.set_killed_spiders(0)


func _on_final_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		character.dialogoinicial=true
		G.dialogo1=false
		directional_light_2d.visible=false
		await get_tree().create_timer(1.0).timeout
		dialogo.dialogoFinal()
	#dialogo
	#desactivar luz
