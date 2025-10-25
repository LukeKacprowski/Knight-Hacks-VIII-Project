extends Control

@onready var label: Label = $Panel/Label
@onready var button: Button = $Panel/Button
@onready var button_2: Button = $Panel/Button2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1.0
	get_tree().paused=false
	
	var winner: int = GameManager.last_run.get("winner",0)
	
	match winner:
		1:
			label.text="Player 1 Wins!"
		2:
			label.text="Player 2 Wins!"
	
	#Connect button actions
	button.pressed.connect(_on_play_again_pressed)
	button_2.pressed.connect(_on_main_menu_pressed)


func _on_play_again_pressed() -> void:
	GameManager.restart_last_level()

func _on_main_menu_pressed() -> void:
	GameManager.goto("main_menu")
