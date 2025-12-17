extends Label

func _ready() -> void:
	# 1. Empezamos visualmente en 0%
	text = "0%"
	G.puntuacion=80
	# 2. Cogemos el valor de tu variable global
	var puntuacion_final = G.puntuacion
	
	# 3. Iniciamos la animación automáticamente
	animar_porcentaje(puntuacion_final)

func animar_porcentaje(valor_final: int) -> void:
	var tween = create_tween()
	
	# Animamos un número desde 0 hasta tu puntuación durante 2 segundos
	# Usamos TRANS_EXPO y EASE_OUT para que empiece rápido y frene al final
	tween.tween_method(actualizar_texto, 0, valor_final, 2.0)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)

func actualizar_texto(valor_actual: int) -> void:
	# Esta función se llama cientos de veces para cambiar el texto
	text = str(valor_actual) + "%"
