extends Node

# Create audio players dynamically
@onready var player1_win_sound = AudioStreamPlayer.new()
@onready var player2_win_sound = AudioStreamPlayer.new()
@onready var player_hit_sound = AudioStreamPlayer.new()
@onready var sword_clash_sound = AudioStreamPlayer.new()

func _ready():
	# Add all to scene
	add_child(player1_win_sound)
	add_child(player2_win_sound)
	add_child(player_hit_sound)
	add_child(sword_clash_sound)

	# Load your sounds
	player1_win_sound.stream = load("res://Player1wins.mp3")
	player2_win_sound.stream = load("res://Player2wins.mp3")
	player_hit_sound.stream = load("res://Playerhit.mp3")
	sword_clash_sound.stream = load("res://Swordconnecthit.mp3")

# --- Trigger Functions ---

func play_player1_win():
	if player1_win_sound:
		player1_win_sound.play()

func play_player2_win():
	if player2_win_sound:
		player2_win_sound.play()

func play_player_hit():
	if player_hit_sound:
		player_hit_sound.play()

func play_sword_clash():
	if sword_clash_sound:
		sword_clash_sound.play()
		
