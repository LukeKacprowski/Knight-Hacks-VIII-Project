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

@onready var hit_sound_one = AudioStreamPlayer.new()
@onready var hit_sound_two= AudioStreamPlayer.new()
@onready var hit_sound_three=AudioStreamPlayer.new()

@onready var blood_splash=AudioStreamPlayer.new()
@onready var foot_step = AudioStreamPlayer.new()

func _ready():
	#needed for my random calls
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
	
	add_child(hit_sound_one)
	add_child(hit_sound_two)
	add_child(hit_sound_three)
	
	add_child(blood_splash)
	add_child(foot_step)
	



	# Load my SFX
	player1_win_sound.stream = load("res://Assets/audio/sfx/Player1wins.mp3")
	player2_win_sound.stream = load("res://Assets/audio/sfx/Player2wins.mp3")
	player_hit_sound.stream = load("res://Assets/audio/sfx/Playerhit.mp3")
	sword_clash_sound.stream = load("res://Assets/audio/sfx/Swordclashboth.mp3")
	
	#sword clashes
	sword_clash_one.stream = load("res://Assets/audio/sfx/Slashnew1.mp3")
	sword_clash_two.stream = load("res://Assets/audio/sfx/Slashnew2.mp3")
	sword_clash_three.stream = load("res://Assets/audio/sfx/Slashnew3.mp3")
	
	#playerhit
	hit_sound_one.stream =load("res://Assets/audio/sfx/hitsound1.mp3")
	hit_sound_two.stream = load("res://Assets/audio/sfx/hitsound2.mp3")
	hit_sound_three.stream = load("res://Assets/audio/sfx/hitsound3.mp3")
	
	#other sfx added
	blood_splash.stream= load("res://Assets/audio/sfx/bloodsplash.mp3")
	foot_step.stream= load("res://Assets/audio/sfx/footstep.mp3")
	
	#Load Backgroundmusic
	menu_music.stream = load("res://Assets/audio/music/Menumusic.mp3")
	game_music.stream = load("res://Assets/audio/music/gameinmusic.mp3")
	
	menu_music.stream.set_loop(true)
	game_music.stream.set_loop(true)
	
	# Adjust volume
	blood_splash.volume_db = 6
	foot_step.volume_db = -2   




#Functions
func play_player1_win():
	if player1_win_sound:
		player1_win_sound.play()

func play_player2_win():
	if player2_win_sound:
		player2_win_sound.play()

#if statement with random number generator to generate random sound
func play_player_hit():
	if player_hit_sound:
		foot_step.play()
		blood_splash.play()
		var rn = randi_range(0, 2)
		if rn == 0:
			hit_sound_one.play()
		elif rn==1:
			hit_sound_two.play()
		elif rn==2:
			hit_sound_three.play()

#if statement with random number generator to generate random sound
func play_sword_clash():
	if sword_clash_sound:
		foot_step.play()
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
		
