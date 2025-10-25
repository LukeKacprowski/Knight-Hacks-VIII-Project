extends Control


func _on_back_pressed() -> void:
	GameManager.goto("how_to_play")


func _on_main_menu_pressed() -> void:
	GameManager.goto("main_menu")
