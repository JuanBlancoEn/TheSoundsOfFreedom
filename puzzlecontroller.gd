# PuzzleController.gd
extends Node

@export var areaPuzzle: Area2D
@export var areaPuzzle2: Area2D

func _process(_delta: float) -> void:
	if areaPuzzle.cajas_dentro >= 1 and areaPuzzle2.cajas_dentro >= 1:
		print("¡Puzzle completado! Cambiando de escena...")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Scenes/mapa2.tscn")
