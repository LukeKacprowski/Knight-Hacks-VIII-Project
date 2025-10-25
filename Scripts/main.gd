extends Node2D

#This tells the start code to wait, for current frame to finish 
func _ready() -> void:
	call_deferred("_start")

# this start the game at the main menu then removesd
# the call when it swicthes to another scence 
func _start() -> void:
	GameManager.goto("main_menu")
	queue_free()
