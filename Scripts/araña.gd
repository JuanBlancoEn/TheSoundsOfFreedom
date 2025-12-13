extends CharacterBody2D

# --- CONFIGURACIÓN ---
@export var speed: float = 80.0
@export var min_distancia: float = 40.0 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $detectionArea 

var target: Node2D = null
var is_attacking: bool = false

func _ready() -> void:
	sprite.play("idle")
	# Esto nos confirma que el script arrancó bien
	print("--- ARAÑA LISTA PARA CAZAR ---")

func _physics_process(delta: float) -> void:
	if target and not is_attacking:
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
		if not is_attacking and sprite.animation != "idle": sprite.play("idle")

	move_and_slide()

# --- SEÑALES DE VISIÓN (EL CHIVATO) ---

func _on_detection_area_body_entered(body: Node2D) -> void:
	# CHIVATO 1: Avisa si ALGO (lo que sea) toca el área
	print("👀 ALGO tocó el área de visión: ", body.name)
	
	if body.is_in_group("character"): 
		# CHIVATO 2: Confirma que detectó al grupo correcto
		print("✅ ¡ES EL JUGADOR! Objetivo fijado.")
		target = body
	else:
		print("❌ No es el jugador (No tiene el grupo 'character')")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		print("💨 El objetivo se escapó.")

# (Mantén las señales de ataque igual que antes)
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		is_attacking = true
		sprite.play("attack")
		body.recibir_dano(10)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		is_attacking = false
