extends Node

# Dictionary for all stats
var stats := {
	"total_games": 0,
	"total_rounds": 0,
	"round_counter": 0,  
	"longest_rounds":0,

	"Player1": {
		"game_wins": 0,
		"round_wins": 0,
		"flawless_victories": 0
	},
	"Player2": {
		"game_wins": 0,
		"round_wins": 0,
		"flawless_victories": 0
	}
}

# Calls when a new round starts
func start_new_round():
	stats["round_counter"] += 1
	print("Starting Round %d" % stats["round_counter"])

#Calls when a player wins a round
func add_round(winner_id: int):
	var player_key = "Player1" if winner_id == 0 else "Player2"
	stats["total_rounds"] += 1
	stats[player_key]["round_wins"] += 1
	print("%s won round %d" % [player_key, stats["round_counter"]])
	print("Round stats updated:", stats)

#Calls when a full game ends
func add_game(winner_id: int, flawless: bool):
	var player_key = "Player1" if winner_id == 0 else "Player2"
	stats["total_games"] += 1
	stats[player_key]["game_wins"] += 1

	if flawless:
		stats[player_key]["flawless_victories"] += 1

	# Update longest round
	if stats["longest_rounds"]<stats["round_counter"] :
		stats["longest_rounds"]=stats["round_counter"]
	

	print("Game finished! %s wins!" % player_key)
	if flawless:
		print("Flawless Victory!")
	print("Game stats updated:", stats)


# Return stats for test andfor ui labels
func get_stats() -> Dictionary:
	return stats
