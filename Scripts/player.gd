extends Node 
class_name PlayerData

var player_id: int
var player_name: String = ""

var lives: int = 3
var max_lives: int = 3

func setup(id: int, name: String):
	player_id = id
	player_name = name
	reset_lives()

func take_damage():
	lives -= 1

func reset_lives():
	lives = max_lives

func get_lives():
	return lives

func is_alive() -> bool:
	return lives > 0
