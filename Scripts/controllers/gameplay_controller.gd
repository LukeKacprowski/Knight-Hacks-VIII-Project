extends Node

@onready var player_data_manager = $GameLogic/PlayerDataManager
@onready var camera = $Camera2D
@onready var round_controller = $GameLogic/RoundController
@onready var animation_controller = $GameLogic/AnimationController

var game_started: bool = false
const base_round_time: float = 6.0
var new_round_time: float = base_round_time  # Initialize with base time

func _ready() -> void:
	#Connect RoundController signals
	round_controller.player_key_pressed.connect(_on_player_key_pressed)
	round_controller.round_timer_updated.connect(_on_round_timer_updated)
	round_controller.round_started.connect(_on_round_started)
	round_controller.player1_wins_round.connect(_on_player1_wins_round)
	round_controller.player2_wins_round.connect(_on_player2_wins_round)
	round_controller.both_players_failed.connect(_on_both_players_failed)
	round_controller.both_players_succeed.connect(_on_both_players_succeed)
	
	#Connect PlayerDataManager signals
	player_data_manager.player_damaged.connect(_on_player_damaged)
	player_data_manager.player_died.connect(_on_player_died)
	
	start_game_sequence()

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
	#Start slow camera zoom

func _on_round_timer_updated(round_time: float):
	new_round_time = round_time
	print("Round time updated: ", new_round_time)

func _on_round_started(p1_letter_sequence: Array, p2_letter_sequence: Array):
	print("Round started signal received")

func _on_both_players_succeed():
	print("Both players succeed!")
	InputManager.end_round()
	
	#Play clash animation
	await get_tree().create_timer(0.5).timeout  # Small delay for visual feedback
	
	start_new_round(new_round_time)

func _on_both_players_failed():
	print("Both players failed!")
	InputManager.end_round()
	
	#Play clash animation
	await get_tree().create_timer(0.5).timeout  # Small delay for visual feedback
	
	start_new_round(new_round_time)

func _on_player1_wins_round():
	print("Player 1 wins round!")
	InputManager.end_round()
	
	#Play clash animation
	await get_tree().create_timer(0.5).timeout  # Small delay for visual feedback
	
	#Player data manager will emit signal for lives
	player_data_manager.apply_damage(1)

func _on_player2_wins_round():
	print("Player 2 wins round!")
	InputManager.end_round()
	
	#Play clash animation
	await get_tree().create_timer(0.5).timeout  # Small delay for visual feedback
	
	#Player data manager will emit signal for lives
	player_data_manager.apply_damage(0)

func _on_player_key_pressed(player_id: int, correct: bool):
	if player_id == 0:
		if correct:
			print("P1 correct key")
			#Play correct button animation
		else:
			print("P1 incorrect key")
			#Play incorrect button animation
	else:
		if correct:
			print("P2 correct key")
			#Play correct button animation
		else:
			print("P2 incorrect key")
			#Play incorrect button animation

func _on_player_damaged(player_id: int, lives_left: int):
	print("Player ", player_id, " damaged. Lives left: ", lives_left)
	#Update Lives on player HUD
	if player_id == 0:
		#update p1 HUD
		pass
	else:
		#update p2 HUD
		pass
	
	if lives_left > 0:
		start_new_round(new_round_time)

signal game_over(winner_id: int)

func _on_player_died(player_id: int):
	print("Player ", player_id, " died!")
	#Play death animation
	
	#Show result screen
	var winner_id = 1 - player_id
	print("Winner: Player ", winner_id)
	GameManager.set_winner(winner_id)
	GameManager.goto("results")
	emit_signal("game_over", winner_id)
