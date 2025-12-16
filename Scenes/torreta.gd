extends StaticBody2D

@export var bala_escena: PackedScene 
@export var velocidad_bala: float = 130.0
@onready var bullet_spawner: Node2D = $bulletSpawner
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_disparar)

func _on_disparar():
	if bala_escena:
		var bala = bala_escena.instantiate()
		
		# 1. Posición inicial
		bala.global_position = bullet_spawner.global_position
		
		# 2. Configurar el REBOTE (Física)
		var material_rebote = PhysicsMaterial.new()
		material_rebote.bounce = 1.0   # Rebote máximo
		material_rebote.friction = 0.0 # Sin fricción
		
		if bala is RigidBody2D:
			bala.physics_material_override = material_rebote
			bala.gravity_scale = 0.0
			bala.lock_rotation = true # Importante: Bloqueamos el cuerpo, no el dibujo
			
			# --- EL EMPUJÓN INICIAL ---
			# Esto solo ocurre UNA vez al nacer. Luego la física decide.
			# Al poner Vector2.RIGHT, sale disparada a la derecha.
			# Si choca con algo, la velocidad cambiará sola.
			bala.linear_velocity = Vector2.RIGHT * velocidad_bala
			
			# Hacemos que el dibujo empiece mirando a la derecha
			bala.rotation = 0.0
			
			bala.add_collision_exception_with(self)

		get_tree().current_scene.add_child(bala)
