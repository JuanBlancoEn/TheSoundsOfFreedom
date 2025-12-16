extends Node2D

@onready var fence1 = $fences1
@onready var character: CharacterBody2D = $Character
@onready var label_fence1: Label = $label_fence1
@onready var label_fence2: Label = $label_fence2
@onready var fence2: TileMapLayer = $fences2
@onready var label_fence3: Label = $label_fence3
@onready var fence3: TileMapLayer = $fences3
@onready var dialogo: Node2D = $Dialogo

var fence3open=false

func _ready() -> void:
	var char=character
	dialogo.dialogoPrincipal(char)
func _process(delta):
	# Si no encontramos al personaje, no hacemos nada para evitar errores
	
	# 2. Leemos la variable del personaje (sincronización constante)
	var diamantes_actuales = character.diamantes
	if is_instance_valid(label_fence1):
		label_fence1.text="UNLOCK IT WITH 11 DIAMONDS \n         YOU HAVE "+str(diamantes_actuales)
	var killed_spiders=character.killed_spiders
	if is_instance_valid(label_fence2):
		label_fence2.text="UNLOCK IT BY KILLING 5 SPIDERS \n   YOU HAVE KILLED "+str(killed_spiders)
	if is_instance_valid(label_fence3):
		label_fence3.text="   UNLOCK IT BY\n OPENING THE CHEST"
	# 3. Comprobamos si llegó a la meta
	if diamantes_actuales >= 11:
		
		# Verificamos si la valla aún existe antes de intentar borrarla
		if is_instance_valid(fence1):
			fence1.queue_free()
			print("¡Meta cumplida! Valla eliminada.")
			label_fence1.queue_free()
			label_fence2.visible=true
			# Opcional: Dejamos de ejecutar _process para ahorrar recursos
			
	
	if killed_spiders>=5:
		if is_instance_valid(fence2):
			fence2.queue_free()
			label_fence2.queue_free()
	if fence3open:
		if is_instance_valid(fence3):
			fence3.queue_free()
			label_fence3.queue_free()
		
func openfence3()->void:
	fence3open=true
