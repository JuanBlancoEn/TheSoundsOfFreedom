extends RigidBody2D

#@export var espejo : RigidBody2D 
#
## Opción 2: Búscalo por nombre (si está en la escena)
#
#func _physics_process(delta) -> void:
	#if espejo: # Verificamos que existe para que no de error
		#global_position = espejo.global_position
