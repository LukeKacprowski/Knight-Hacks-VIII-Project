extends Node

@onready var player_data_manager = $GameLogic/PlayerDataManager
@onready var camera= $Camera2D
@onready var round_controller = $GameLogic/RoundController
@onready var animation_controller = $GameLogic/AnimationController

var game_started: bool = false
const base_round_time: float = 6.0
var new_round_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect InputManager signal
	InputManager.player_key_pressed.connnect(_on_player_key_pressed)
	
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
	round_controller.start_round(round_time)
	#Start slow camera zoom

func _on_round_timer_updated(round_time: float):
	new_round_time = round_time

func _on_round_started(p1_letter_sequence: Array, p2_letter_sequence: Array):
	pass

func _on_both_players_succeed():
	InputManager.end_round()
	
	#Play clash animation
	
	
	start_new_round(new_round_time)

func _on_both_players_failed():
	InputManager.end_round()
	
	#Play clash animation
	
	start_new_round(new_round_time)

func _on_player1_wins_round():
	InputManager.end_round()
	
	#Play clash animation
	
	#Player data manager will emit signal for lives
	pass

func _on_player2_wins_round():
	InputManager.end_round()
	
	#Play clash animation
	
	#Player data manager will emit signal for lives
	pass

func _on_player_key_pressed(player_id: int, correct: bool):
	if player_id == 0:
		if correct == true:
			#Play correct button animation
			pass
		else:
			#Play incorrect button animation
			pass
	else:
		if correct == true:
			#Play correct button animation
			pass
		else:
			#Play incorrect button animation
			pass

func _on_player_damaged(player_id: int, lives_left: int):
	#Update Lives on player HUD
	if player_id == 1:
		#update p1 HUD
		pass
	else:
		#update p2 HUD
		pass
	
	if lives_left > 0:
		start_new_round(new_round_time)

func _on_player_died(player_id: int):
	#Play death animation
	
	#Show result screen
	var winnner_id = 1 - player_id
