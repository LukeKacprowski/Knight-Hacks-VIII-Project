extends Node

# Create audio players dynamically
@onready var player1_win_sound = AudioStreamPlayer.new()
@onready var player2_win_sound = AudioStreamPlayer.new()
@onready var player_hit_sound = AudioStreamPlayer.new()
@onready var sword_clash_sound = AudioStreamPlayer.new()
@onready var menu_music = AudioStreamPlayer.new()
@onready var game_music = AudioStreamPlayer.new()

@onready var sword_clash_one = AudioStreamPlayer.new()
@onready var sword_clash_two = AudioStreamPlayer.new()
@onready var sword_clash_three = AudioStreamPlayer.new()



func _ready():
	randomize()
	# Add all to scene
	add_child(player1_win_sound)
	add_child(player2_win_sound)
	add_child(player_hit_sound)
	add_child(sword_clash_sound)
	add_child(menu_music)
	add_child(game_music)
	
	add_child(sword_clash_one)
	add_child(sword_clash_two)
	add_child(sword_clash_three)



	# Load your SFX
	player1_win_sound.stream = load("res://Assets/audio/sfx/Player1wins.mp3")
	player2_win_sound.stream = load("res://Assets/audio/sfx/Player2wins.mp3")
	player_hit_sound.stream = load("res://Assets/audio/sfx/Playerhit.mp3")
	sword_clash_sound.stream = load("res://Assets/audio/sfx/Swordclashboth.mp3")
	
	#sword clashes
	sword_clash_one.stream = load("res://Assets/audio/sfx/Slashnew1.mp3")
	sword_clash_two.stream = load("res://Assets/audio/sfx/Slashnew2.mp3")
	sword_clash_three.stream = load("res://Assets/audio/sfx/Slashnew3.mp3")
	
	#Load Backgroundmusic
	menu_music.stream = load("res://Assets/audio/music/Menumusic.mp3")
	game_music.stream = load("res://Assets/audio/music/gameinmusic.mp3")
	
	menu_music.stream.set_loop(true)
	game_music.stream.set_loop(true)

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
		var rn = randi_range(0, 1)
		if rn == 0:
			sword_clash_one.play()
		elif rn==1:
			sword_clash_three.play()

#Background music functions
func play_menu_music():
	stop_all_music()
	menu_music.play()

func play_game_music():
	stop_all_music()
	game_music.play()

func stop_all_music():
	menu_music.stop()
	game_music.stop()
		
