extends Node

@onready var player_data_manager = $GameLogic/PlayerDataManager
@onready var camera = $Camera2D
@onready var round_controller = $GameLogic/RoundController
@onready var animation_controller = $GameLogic/AnimationController
@onready var letter_display_manager = $GameLogic/LetterDisplayManager
@onready var timer = $UI/Timer
@onready var p1_letter_container = $"UI/Player1HUD/Letter Container"
@onready var p2_letter_container = $"UI/Player2HUD/Letter Container"

var game_started: bool = false
const base_round_time: float = 6.0
var new_round_time: float = base_round_time

func _ready() -> void:
	# Wait one frame for all @onready variables to initialize
	await get_tree().process_frame
	
	# Set up letter display manager with container references
	letter_display_manager.set_containers(p1_letter_container, p2_letter_container)
	
	# Connect RoundController signals
	round_controller.player_key_pressed.connect(_on_player_key_pressed)
	round_controller.round_timer_updated.connect(_on_round_timer_updated)
	round_controller.round_started.connect(_on_round_started)
	round_controller.player1_wins_round.connect(_on_player1_wins_round)
	round_controller.player2_wins_round.connect(_on_player2_wins_round)
	round_controller.both_players_failed.connect(_on_both_players_failed)
	round_controller.both_players_succeed.connect(_on_both_players_succeed)
	
	# Connect PlayerDataManager signals
	player_data_manager.player_damaged.connect(_on_player_damaged)
	player_data_manager.player_died.connect(_on_player_died)
	
	start_game_sequence()

func _process(delta: float) -> void:
	# Update timer display
	if round_controller.round_active:
		timer.update_time(round_controller.current_time)

func start_game_sequence():
	play_intro()
	game_started = true
	start_new_round(base_round_time)

func play_intro():
	pass

func start_new_round(round_time: float):
	print("Starting new round with time: ", round_time)
	round_controller.start_round(round_time)
	InputManager.reset_round()
	timer.start_timer(round_time)

func _on_round_timer_updated(round_time: float):
	new_round_time = round_time
	print("Round time updated: ", new_round_time)

func _on_round_started(p1_letter_sequence: Array, p2_letter_sequence: Array):
	print("Round started signal received")
	letter_display_manager.spawn_letters(p1_letter_sequence, p2_letter_sequence)

func _on_both_players_succeed():
	print("Both players succeed!")
	InputManager.end_round()
	
	await get_tree().create_timer(0.5).timeout
	
	start_new_round(new_round_time)

func _on_both_players_failed():
	print("Both players failed!")
	InputManager.end_round()
	
	await get_tree().create_timer(0.5).timeout
	
	start_new_round(new_round_time)

func _on_player1_wins_round():
	print("Player 1 wins round!")
	InputManager.end_round()
	
	await get_tree().create_timer(0.5).timeout
	
	player_data_manager.apply_damage(1)

func _on_player2_wins_round():
	print("Player 2 wins round!")
	InputManager.end_round()
	
	await get_tree().create_timer(0.5).timeout
	
	player_data_manager.apply_damage(0)

func _on_player_key_pressed(player_id: int, correct: bool):
	if player_id == 0:
		if correct:
			print("P1 correct key")
			letter_display_manager.play_letter_animation(0, true)
		else:
			print("P1 incorrect key")
			letter_display_manager.play_letter_animation(0, false)
	else:
		if correct:
			print("P2 correct key")
			letter_display_manager.play_letter_animation(1, true)
		else:
			print("P2 incorrect key")
			letter_display_manager.play_letter_animation(1, false)

func _on_player_damaged(player_id: int, lives_left: int):
	print("Player ", player_id + 1, " damaged. Lives left: ", lives_left)
	
	if lives_left > 0:
		start_new_round(new_round_time)

signal game_over(winner_id: int)

func _on_player_died(player_id: int):
	print("Player ", player_id + 1, " died!")
	
	var winner_id = 1 - player_id
	print("Winner: Player ", winner_id + 1)
	GameManager.set_winner(winner_id)
	GameManager.goto("results")
	emit_signal("game_over", winner_id)
