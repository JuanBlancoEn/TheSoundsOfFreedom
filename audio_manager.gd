extends Node2D

@onready var exploration: AudioStreamPlayer2D = $Exploration
@onready var combat: AudioStreamPlayer2D = $Combat
@onready var diamond: AudioStreamPlayer2D = $Diamond
@onready var spider_death: AudioStreamPlayer2D = $SpiderDeath
@onready var bullets: AudioStreamPlayer2D = $Bullets
@onready var fences: AudioStreamPlayer2D = $Fences

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
	
func kill_spider():
	spider_death.play()
	
func shoot_bullet():
	bullets.play()
	
func opening_fences():
	fences.play()
