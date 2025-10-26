extends TextureProgressBar

var player_id: int = 0
var max_lives: int = 3
var player_data: PlayerData = null

func _ready() -> void:
	pass

func setup(id: int, starting_lives: int = 3):
	player_id = id
	max_lives = starting_lives
	
	# Setup health bar values
	max_value = max_lives
	value = starting_lives
	
	# Set fill mode based on player (left or right)
	if player_id == 1:
		fill_mode = FILL_LEFT_TO_RIGHT  # Player 1 bar fills left to right
	else:
		fill_mode = FILL_RIGHT_TO_LEFT  # Player 2 bar fills right to left
	
	# Connect to player data
	connect_to_player_data()

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
	
	print("HealthBar ", player_id, " connected to player data")

func _on_lives_changed(new_lives: int):
	print("HealthBar ", player_id, " received lives changed: ", new_lives)
	update_health_bar(new_lives)

func _on_player_died():
	print("HealthBar ", player_id, " received player died signal")
	update_health_bar(0)

func update_health_bar(current_lives: int):
	# Animate the health bar change
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", current_lives, 0.3)


func get_current_lives() -> int:
	if player_data:
		return player_data.get_lives()
	return 0
