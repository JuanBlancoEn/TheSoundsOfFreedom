extends CharacterBody2D

# --- CONFIGURACIÓN ---
@export var speed: float = 80.0
@export var min_distancia: float = 40.0 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $detectionArea 

var target: Node2D = null
var is_attacking: bool = false
var life: int = 20
var is_moving: bool = true

# --- VARIABLES NUEVAS PARA EL ATAQUE ---
var attack_victim: Node2D = null # Guardamos a quién pegar
var attack_timer: float = 0.0    # Cuenta atrás para el siguiente golpe

func _ready() -> void:
	sprite.play("idle")
	print("--- ARAÑA LISTA PARA CAZAR ---")

func _physics_process(delta: float) -> void:
	# 1. Si está muerta, no hacemos nada más
	if life <= 0:
		return

	# 2. LÓGICA DE ATAQUE (Nuevo bloque)
	# Si estamos atacando y tenemos una víctima...
	if is_attacking and attack_victim:
		attack_timer -= delta # Restamos tiempo
		
		if attack_timer <= 0:
			# ¡MOMENTO DEL GOLPE!
			sprite.play("attack")
			# Verificamos que tenga la función recibir_dano antes de llamar
			if attack_victim.has_method("recibir_dano"):
				attack_victim.recibir_dano(10)
			
			# Reiniciamos el reloj a 1 segundo para el próximo golpe
			attack_timer = 1.5

	# 3. LÓGICA DE MOVIMIENTO
	if target and not is_attacking and is_moving:
		var distancia = global_position.distance_to(target.global_position)
		if distancia > min_distancia:
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * speed
			
			if direction.x < 0: sprite.flip_h = false 
			else: sprite.flip_h = true
			
			if sprite.animation != "walk": sprite.play("walk")
		else:
			velocity = Vector2.ZERO
			if sprite.animation != "idle": sprite.play("idle")
	else:
		velocity = Vector2.ZERO
		# Solo ponemos IDLE si NO estamos atacando para no cortar la animación de golpe
		if not is_attacking and sprite.animation != "idle": 
			sprite.play("idle")

	move_and_slide()

# --- SEÑALES DE VISIÓN ---

func _on_detection_area_body_entered(body: Node2D) -> void:
	print("👀 ALGO tocó el área de visión: ", body.name)
	if body.is_in_group("character"): 
		print("✅ ¡ES EL JUGADOR! Objetivo fijado.")
		target = body
	else:
		print("❌ No es el jugador")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		print("💨 El objetivo se escapó.")

# --- SEÑALES DE ATAQUE (MODIFICADAS) ---

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		is_attacking = true
		attack_victim = body # Guardamos la referencia
		attack_timer = 0.0   # Ponemos 0 para que el primer golpe sea INSTANTÁNEO

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		is_attacking = false
		attack_victim = null # Olvidamos a la víctima
		
func damage(damage_amount: int) -> void: # Cambié el nombre del argumento para evitar confusión
	life -= damage_amount
	if life <= 0:
		is_moving = false
		sprite.play("die")
		# Tu timer de muerte (ajustado a tu gusto)
		get_tree().create_timer(1.40).timeout.connect(queue_free)
