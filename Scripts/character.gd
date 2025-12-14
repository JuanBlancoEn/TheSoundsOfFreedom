extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# Asegúrate de que el nodo de luz se llame exactamente así o arrástralo aquí
@onready var luz: PointLight2D = $PointLight2D 

@onready var  barra_vida: ProgressBar = $"../CanvasLayer/ProgressBar"
@onready var bullet_spawner: Node2D = $bulletSpawner


@export var velocidad : float = 150.0
@export var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
func _input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()
# Variable para guardar el tween actual (por si coges otro diamante antes de acabar)
var tween_luz: Tween
var vida_maxima: float = 100.0
var vida_actual: float = 100.0
var diamantes:int =0;
func _ready():
	# Configuración inicial de la barra al empezar el juego
	if barra_vida:
		barra_vida.max_value = vida_maxima
		barra_vida.value = vida_actual
		# Opcional: Ocultar el porcentaje de texto si no te gusta
		barra_vida.show_percentage = false

func recibir_dano(cantidad: float):
	vida_actual -= cantidad
	
	# Aseguramos que la vida no baje de 0
	if vida_actual < 0:
		vida_actual = 0
	
	# Actualizamos la barra visualmente
	if barra_vida:
		barra_vida.value = vida_actual
		
	print("Vida actual: ", vida_actual)
	
	#if vida_actual == 0:
		#morir()

func _physics_process(delta):
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
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
		
		# Verificamos si lo que tocamos es un RigidBody (la caja)
		if objeto_tocado is RigidBody2D:
			# Calculamos la dirección del empuje (inversa a la normal del choque)
			var direccion_empuje = -colision.get_normal()
			
			# Aplicamos fuerza. Ajusta el '50.0' si quieres más o menos fuerza.
			# Usamos 'apply_central_impulse' para un empujón instantáne
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
# --- NUEVA FUNCIÓN PARA EL EFECTO DEL DIAMANTE ---
func activar_super_luz():
	if luz:
		# 1. Limpieza: Si ya hay una animación activa, la detenemos
		if tween_luz:
			tween_luz.kill()
		
		# 2. Configuración Inicial (EL ESTALLIDO)
		# Usamos 'texture_scale' que es específico para el tamaño de la luz
		# Ponemos un valor alto (ej: 6.0) para que sea "muy grande"
		luz.texture_scale = 6.0 
		luz.energy = 2.5 # Opcional: Aumentamos el brillo también para más impacto
		
		# 3. Creamos el Tween
		tween_luz = create_tween()
		
		# set_parallel(true) permite animar escala y energía al mismo tiempo
		tween_luz.set_parallel(true)
		
		# 4. La animación de disminución
		# TRANS_EXPO + EASE_OUT hace que baje rápido al principio y suave al final
		tween_luz.tween_property(luz, "texture_scale", 1.0, 5.0)\
			.set_trans(Tween.TRANS_EXPO)\
			.set_ease(Tween.EASE_OUT)
			
		# Opcional: Devolver la energía (brillo) a la normalidad (asumiendo que es 1.0)
		tween_luz.tween_property(luz, "energy", 1.0, 5.0)\
			.set_trans(Tween.TRANS_EXPO)\
			.set_ease(Tween.EASE_OUT)
		
func shoot():
	# ... (tus comprobaciones de seguridad e instancias anteriores) ...
	if bullet_spawner == null: return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_spawner.global_position

	# --- 1. CONFIGURACIÓN DE REBOTE MÁXIMO ---
	# Creamos un material físico nuevo "al vuelo"
	var material_rebote = PhysicsMaterial.new()
	material_rebote.bounce = 1.0   # 1.0 es el máximo (rebote perfecto)
	material_rebote.friction = 0.0 # 0.0 para que no pierda velocidad al rozar paredes
	
	# Se lo aplicamos a la bala
	if bullet is RigidBody2D:
		bullet.physics_material_override = material_rebote
		bullet.gravity_scale = 0.0 # Aseguramos que no caiga
		# Bloqueamos la rotación para que el rebote sea más predecible (opcional)
		bullet.lock_rotation = true 

	# ... (resto de cálculo de dirección y velocidad) ...
	var direction = (get_global_mouse_position() - bullet_spawner.global_position).normalized()
	bullet.linear_velocity = direction * 800.0 
	
	get_tree().current_scene.add_child(bullet)
	get_tree().create_timer(2.0).timeout.connect(bullet.queue_free)
	
	# --- 2. EVITAR QUE CHOQUE CON EL PERSONAJE ---
	bullet.add_collision_exception_with(self)
func plus1Diamante():
	diamantes+=1
