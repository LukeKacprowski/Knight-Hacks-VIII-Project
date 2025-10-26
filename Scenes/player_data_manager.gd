extends Node
class_name PlayerDataManager

signal player_damaged(player_id: int, lives_left: int)
signal player_died(player_id: int)

@onready var player1_data = $Player1Data
@onready var player2_data = $Player2Data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Player Setup
	player1_data.setup(0, "Player 1")
	player2_data.setup(1, "Player 2")
	
	#Connect to signals
	player1_data.lives_changed.connect(_on_player1_lives_changed)
	player2_data.lives_changed.connect(_on_player2_lives_changed)
	player1_data.player_died.connect(_on_player1_died)
	player2_data.player_died.connect(_on_player2_died)

func get_player_data(player_id: int) -> Node:
	if player_id == 0:
		return player1_data
	else:
		return player2_data

func apply_damage(player_id: int):
	var player = get_player_data(player_id)
	player.take_damage()

func get_player_lives(player_id: int):
	return get_player_data(player_id).get_lives()

func is_player_alive(player_id: int) -> bool:
	return get_player_data(player_id).is_alive()

func reset_all_players():
	player1_data.reset_lives()
	player2_data.reset_lives()

func get_winner() -> int:
	if not player1_data.is_alive():
		return 1
	elif not player2_data.is_alive():
		return 2
	else:
		return -1

#Signal Forwarders
func _on_player1_lives_changed(new_lives: int):
	emit_signal("player_damaged", 0, new_lives)

func _on_player2_lives_changed(new_lives: int):
	emit_signal("player_damaged", 1, new_lives)

func _on_player1_died():
	emit_signal("player_died", 0)

func _on_player2_died():
	emit_signal("player_died", 1)
