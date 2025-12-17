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
func _process(delta):
	# Si no encontramos al personaje, no hacemos nada para evitar errores
	
	# 2. Leemos la variable del personaje (sincronización constante)
	var diamantes_actuales = character.diamantes
	if is_instance_valid(label_fence1):
		label_fence1.text="UNLOCK IT WITH 11 DIAMONDS \n         YOU HAVE "+str(diamantes_actuales)
	killed_spiders=character.killed_spiders
	
	if is_instance_valid(label_fence2):
		label_fence2.text="UNLOCK IT BY KILLING 5 SPIDERS \n   YOU HAVE KILLED "+str(killed_spiders)
	if is_instance_valid(label_fence3):
		label_fence3.text="   UNLOCK IT BY\n OPENING THE CHEST"
	# 3. Comprobamos si llegó a la meta
	if diamantes_actuales >= 11:
		
		# Verificamos si la valla aún existe antes de intentar borrarla
		if is_instance_valid(fence1):
			AudioManager.opening_fences()
			fence1.queue_free()
			print("¡Meta cumplida! Valla eliminada.")
			label_fence1.queue_free()
			label_fence2.visible=true
			# Opcional: Dejamos de ejecutar _process para ahorrar recursos
			
	
	if killed_spiders>=5:
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
