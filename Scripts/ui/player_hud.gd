extends Control

@onready var player_label = $VBoxContainer/PlayerLabel
@onready var lives_container = $VBoxContainer/LivesContainer
@onready var letter_container = $"Letter Container"

var player_id: int = 0
var max_lives: int = 3
var player_data: PlayerData = null

# Load heart texture
var heart_texture = preload("res://Assets/ui/main_menu/pixellab-red-heart--1761426065293.png")

func _ready() -> void:
	pass

func setup(id: int, player_name: String, starting_lives: int = 3):
	player_id = id
	max_lives = starting_lives
	
	if player_label:
		player_label.text = player_name
	
	# Connect to player data
	connect_to_player_data()
	
	# Initial display
	update_lives_display(starting_lives)

func connect_to_player_data():
	# Find the player data node
	var player_data_manager = get_node("../../GameLogic/PlayerDataManager")
	
	if not player_data_manager:
		push_error("PlayerHUD: Could not find PlayerDataManager!")
		return
	
	# Get the correct player data node
	if player_id == 0:
		player_data = player_data_manager.get_node("Player1Data")
	else:
		player_data = player_data_manager.get_node("Player2Data")
	
	if not player_data:
		push_error("PlayerHUD: Could not find Player data for player ", player_id)
		return
	
	# Connect to the player's signals
	if not player_data.lives_changed.is_connected(_on_lives_changed):
		player_data.lives_changed.connect(_on_lives_changed)
	
	if not player_data.player_died.is_connected(_on_player_died):
		player_data.player_died.connect(_on_player_died)
	
	print("PlayerHUD ", player_id, " connected to player data")

func _on_lives_changed(new_lives: int):
	print("PlayerHUD ", player_id, " received lives changed: ", new_lives)
	lose_life_animation(new_lives)

func _on_player_died():
	print("PlayerHUD ", player_id, " received player died signal")
	# Could add special death animation here
	update_lives_display(0)

func update_lives_display(current_lives: int):
	if not lives_container:
		return
	
	# Clear existing life indicators
	for child in lives_container.get_children():
		child.queue_free()
	
	# Create life indicators using heart sprites
	for i in range(max_lives):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # Pixel-perfect rendering
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		heart.custom_minimum_size = Vector2(32, 32)  # Adjust size as needed
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		if i < current_lives:
			# Full heart - full opacity
			heart.modulate = Color(1, 1, 1, 1)
		else:
			# Lost heart - dark/transparent
			heart.modulate = Color(0.3, 0.3, 0.3, 0.5)
		
		lives_container.add_child(heart)

func lose_life_animation(remaining_lives: int):
	# Wait one frame to ensure hearts are spawned
	await get_tree().process_frame
	
	# Animate the life loss
	if lives_container and lives_container.get_child_count() > remaining_lives:
		var lost_heart = lives_container.get_child(remaining_lives)
		
		if not lost_heart:
			update_lives_display(remaining_lives)
			return
		
		# Flash and fade the lost heart
		var tween = create_tween()
		tween.set_parallel(true)
		
		# Flash red briefly
		tween.tween_property(lost_heart, "modulate", Color(1, 0, 0, 1), 0.1)
		tween.tween_property(lost_heart, "scale", Vector2(1.5, 1.5), 0.15)
		
		await tween.finished
		
		# Fade to dark
		var tween2 = create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(lost_heart, "modulate", Color(0.3, 0.3, 0.3, 0.5), 0.3)
		tween2.tween_property(lost_heart, "scale", Vector2.ONE, 0.15)
		
		await tween2.finished
	else:
		# Fallback if animation fails
		update_lives_display(remaining_lives)

func flash_hud():
	# Flash the entire HUD to show activity
	var original_modulate = modulate
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), 0.1)
	tween.tween_property(self, "modulate", original_modulate, 0.1)

func get_current_lives() -> int:
	if player_data:
		return player_data.get_lives()
	return 0
