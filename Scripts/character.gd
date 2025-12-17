extends CharacterBody2D

@onready var onda: AnimatedSprite2D = $Onda
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var luz: PointLight2D = $PointLight2D 
@onready var barra_vida: ProgressBar = $"../CanvasLayer/ProgressBar"
@onready var bullet_spawner: Node2D = $bulletSpawner

@export var velocidad : float = 150.0
@export var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")

# --- NUEVA VARIABLE ---
var can_shoot: bool = true
# ----------------------

var tween_luz: Tween
var vida_maxima: float = 100.0
var vida_actual: float = 100.0
var diamantes:int =0
var killed_spiders:int=0
var dialogoinicial=true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func _ready():
	onda.play("idle")
	if barra_vida:
		barra_vida.max_value = vida_maxima
		barra_vida.value = vida_actual
		barra_vida.show_percentage = false

func recibir_dano(cantidad: float):
	vida_actual -= cantidad
	if vida_actual < 0:
		vida_actual = 0
	
	if barra_vida:
		barra_vida.value = vida_actual
		
	print("Vida actual: ", vida_actual)
	
	if vida_actual == 0:
		morir()

func _physics_process(delta):
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if !dialogoinicial:
		if direccion:
			velocity = direccion * velocidad
			animacion(direccion)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, velocidad)
			animated_sprite_2d.play("idle")
		
		move_and_slide()
	
		for i in get_slide_collision_count():
			var colision = get_slide_collision(i)
			var objeto_tocado = colision.get_collider()
		
			if objeto_tocado is RigidBody2D:
				var direccion_empuje = -colision.get_normal() * 800
				objeto_tocado.apply_central_impulse(direccion_empuje)

func animacion(dir: Vector2):
	var angulo = dir.angle()
	var index = int(round(angulo / (PI / 4)))
	index = posmod(index, 8)
	
	var anim_names = [
		"walk_right", "w_down_right", "walk_down", "w_down_left", 
		"walk_left", "w_up_left", "walk_up", "w_up_right"
	]
	
	animated_sprite_2d.play(anim_names[index])

func activar_super_luz():
	onda.stop()
	onda.play("super_onda")

	if luz and !dialogoinicial:
		if tween_luz:
			tween_luz.kill()
		
		luz.texture_scale = 6.0 
		luz.energy = 2.5
		
		tween_luz = create_tween()
		tween_luz.set_parallel(true)
		
		tween_luz.tween_property(luz, "texture_scale", 1.0, 5.0)\
			.set_trans(Tween.TRANS_EXPO)\
			.set_ease(Tween.EASE_OUT)
			
		tween_luz.tween_property(luz, "energy", 1.0, 5.0)\
			.set_trans(Tween.TRANS_EXPO)\
			.set_ease(Tween.EASE_OUT)

func shoot():
	# 1. Comprobamos si podemos disparar (can_shoot) y no estamos en dialogo
	if !dialogoinicial and can_shoot:
		
		if bullet_spawner == null: return
		var bullet = bullet_scene.instantiate()
		bullet.global_position = bullet_spawner.global_position

		var material_rebote = PhysicsMaterial.new()
		material_rebote.bounce = 1.0   
		material_rebote.friction = 0.0 
		
		if bullet is RigidBody2D:
			bullet.physics_material_override = material_rebote
			bullet.gravity_scale = 0.0 
			bullet.lock_rotation = true 

		var direction = (get_global_mouse_position() - bullet_spawner.global_position).normalized()
		bullet.linear_velocity = direction * 80.0 
		
		AudioManager.shoot_bullet()
		get_tree().current_scene.add_child(bullet)
		get_tree().create_timer(2.0).timeout.connect(bullet.queue_free)
		
		bullet.add_collision_exception_with(self)
		
		# --- MODIFICACIÓN AQUÍ ---
		# Usamos tu variable global G.light_set
		# Si es 0.60 (Difícil), activamos el cooldown
		if G.light_level <= 0.60:
			can_shoot = false # Bloqueamos disparo
			# Esperamos 0.5 segundos y desbloqueamos
			get_tree().create_timer(0.5).timeout.connect(func(): can_shoot = true)

func plus1Diamante():
	diamantes+=1
	print(diamantes)

func morir():
	print("💀 Jugador eliminado. Reiniciando nivel...")
	set_physics_process(false) 
	get_tree().create_timer(0.5).timeout.connect(get_tree().reload_current_scene)

func registrar_muerte_arana():
	killed_spiders += 1
	print("1 araña menos")

func set_light(rango: float) -> void:
	print("ESCALA CAMBIADA")
	luz.scale *= rango

func dialogoinicialacabado()->void:
	dialogoinicial=false
	
func set_killed_spiders(num:int)->void:
	killed_spiders=num
