extends Node2D

@onready var exploration: AudioStreamPlayer2D = $Exploration
@onready var combat: AudioStreamPlayer2D = $Combat
@onready var diamond: AudioStreamPlayer2D = $Diamond

func _ready() -> void:
	exploration.play()
	
func change_to_combat():
	if not combat.playing:
		exploration.stop()
		combat.play()
		
func change_to_exploration():
	if not exploration.playing:
		combat.stop()
		exploration.play()
		
func pick_diamond():
	diamond.play()
