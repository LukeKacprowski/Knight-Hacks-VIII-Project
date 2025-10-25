<<<<<<< HEAD
extends Node
class_name PlayerData

var player_id: int = 0
=======
extends Node 
class_name PlayerData

var player_id: int
>>>>>>> parent of 19dab6c (Merge branch 'main' of https://github.com/LukeKacprowski/Knight-Hacks-VIII-Project)
var player_name: String = ""

var lives: int = 3
var max_lives: int = 3

<<<<<<< HEAD
signal lives_changed(new_lives: int)
signal player_died

=======
>>>>>>> parent of 19dab6c (Merge branch 'main' of https://github.com/LukeKacprowski/Knight-Hacks-VIII-Project)
func setup(id: int, name: String):
	player_id = id
	player_name = name
	reset_lives()

func take_damage():
	lives -= 1
	emit_signal("lives_changed", lives)
	
	if lives <= 0:
		emit_signal("player_died")

func reset_lives():
	lives = max_lives
	emit_signal("lives_changed", lives)

func get_lives():
	return lives

func is_alive() -> bool:
	return lives > 0
