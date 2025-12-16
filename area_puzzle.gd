# AreaPuzzle.gd
extends Area2D

var cajas_dentro := 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("cajas1"):
		cajas_dentro += 1
		print(name, "cajas dentro:", cajas_dentro)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("cajas1"):
		cajas_dentro -= 1
		print(name, "cajas dentro:", cajas_dentro)
