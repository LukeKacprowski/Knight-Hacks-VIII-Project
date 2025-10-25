extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func take_damage():
	lives -= 1

func reset_lives():
	lives = max_lives

func get_lives():
	return lives

func is_alive() -> bool:
	return lives > 0
