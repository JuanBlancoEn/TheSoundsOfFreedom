extends Area2D

var esta_activa : bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Conecta las señales por código si no lo hiciste en el editor (opcional)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Verificamos si lo que entró es un Jugador O una Caja
	if body is CharacterBody2D or body is RigidBody2D:
		activar_placa()

func _on_body_exited(body):
	# Cuando algo sale, tenemos que comprobar si QUEDA ALGO MÁS encima.
	# Si no hacemos esto, al salir tú, la placa se apagaría 
	# aunque hubieras dejado una caja encima.
	if body is CharacterBody2D or body is RigidBody2D:
		check_si_queda_peso()

func activar_placa():
	if not esta_activa:
		esta_activa = true
		print("¡Placa Activada!")
		
		animated_sprite_2d.play("on")
		

func check_si_queda_peso():
	var cuerpos_dentro = get_overlapping_bodies()
	
	var sigue_habiendo_peso = false
	
	for cuerpo in cuerpos_dentro:
		if cuerpo is CharacterBody2D or cuerpo is RigidBody2D:
			sigue_habiendo_peso = true
			break 
	
	if not sigue_habiendo_peso:
		desactivar_placa()

func desactivar_placa():
	esta_activa = false
	print("Placa Desactivada")
	animated_sprite_2d.play("off")
