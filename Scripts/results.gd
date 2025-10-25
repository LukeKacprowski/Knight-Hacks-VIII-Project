extends Control

@onready var label: Label = $Panel/Label
@onready var play_again_button: Button = $Panel/play_again_button
@onready var main_menu_button: Button = $Panel/main_menu_button


func _ready() -> void:
	# Button handlers (assign lambdas to vars first if your version requires it)
	var _play_again := func() -> void: GameManager.goto("gameplay")
	var _main_menu  := func() -> void: GameManager.goto("main_menu")
	play_again_button.pressed.connect(_play_again)
	main_menu_button.pressed.connect(_main_menu)
	AudioManager.play_menu_music()

	# Pull winner from GameManager and update label
	var w: int = GameManager.get_winner()
	_update_result_label(w)

func _update_result_label(winner_id: int) -> void:
	match winner_id:
		0: label.text = "Player 1 Wins!"
		1: label.text = "Player 2 Wins!"
