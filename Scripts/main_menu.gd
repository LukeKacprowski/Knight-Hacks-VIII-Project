extends Control

# This button brings the user to the game play scene
func _on_start_pressed() -> void:
	GameManager.goto("gameplay")

# Takes the user to the hoe to play game 
func _on_how_to_play_pressed() -> void:
	GameManager.goto("how_to_play")

# Quits the game 
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_stats_pressed() -> void:
	GameManager.goto("Stats")
