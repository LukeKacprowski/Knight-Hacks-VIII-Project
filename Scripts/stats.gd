extends  Panel

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
