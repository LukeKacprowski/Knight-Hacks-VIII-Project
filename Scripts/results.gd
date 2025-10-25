extends Control

@onready var label: Label = $Panel/Label
@onready var play_again_button: Button = $Panel/play_again_button
@onready var main_menu_button: Button = $Panel/main_menu_button

var _winner_id: int = -1

func _ready() -> void:
	var _play_again_func := func() -> void:
		GameManager.goto("gameplay")
	
	var _main_menu_func := func() -> void:
		GameManager.goto("main_menu")
	
	if _winner_id != -1:
		_apply_winner_text(_winner_id)

	# Connect button actions
	play_again_button.pressed.connect(_play_again_func)
	main_menu_button.pressed.connect(_main_menu_func)

func set_winner(winner_id: int) -> void:
	_winner_id = winner_id
	if is_inside_tree():
		_apply_winner_text(winner_id)

func _apply_winner_text(winner_id: int) -> void:
	match winner_id:
		1:
			label.text = "Player 1 Wins!"
		2:
			label.text = "Player 2 Wins!"
