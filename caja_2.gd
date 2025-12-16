extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_puzzle_body_entered(body: Node2D) -> void:
	print(body.name)


func _on_area_puzzle_2_body_entered(body: Node2D) -> void:
	print(body.name)
