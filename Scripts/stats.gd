extends  Node

@onready var total_games: Label = $VBoxContainer/total_games
@onready var total_round_wins: Label = $"VBoxContainer/total_round wins"
@onready var round_count: Label = $VBoxContainer/Round_count
@onready var p_1_gw: Label = $VBoxContainer/P1_GW
@onready var p_1_rw: Label = $VBoxContainer/P1_RW
@onready var p_1_flawless: Label = $VBoxContainer/P1_flawless
@onready var p_2_gw: Label = $VBoxContainer/P2_GW
@onready var p_2_rw: Label = $VBoxContainer/P2_RW
@onready var p_2_flawless: Label = $VBoxContainer/P2_flawless

func _ready():
	update_stats()

func update_stats():
	var s = StatsManager.get_stats()
	
	#total stats
	total_games.text = "Total Games: " + str(s["total_games"])
	total_round_wins.text = "Total Round Wins: " + str(s["total_rounds"])
	round_count.text = "Longest Round Streak: " + str(s["round_counter"])

	#Player 1 stats
	p_1_gw.text = "P1 Game Wins: " + str(s["Player1"]["game_wins"])
	p_1_rw.text = "P1 Round Wins: " + str(s["Player1"]["round_wins"])
	p_1_flawless.text = "P1 Flawless: " + str(s["Player1"]["flawless_victories"])

	# ✅ Player 2 stats
	p_2_gw.text = "P2 Game Wins: " + str(s["Player2"]["game_wins"])
	p_2_rw.text = "P2 Round Wins: " + str(s["Player2"]["round_wins"])
	p_2_flawless.text = "P2 Flawless: " + str(s["Player2"]["flawless_victories"])


func _on_main_menu_pressed() -> void:
	GameManager.goto("main_menu")
