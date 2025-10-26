extends Node

@onready var player_data_manager = $GameLogic/PlayerDataManager
@onready var camera = $Camera2D
@onready var round_controller = $GameLogic/RoundController
@onready var animation_controller = $GameLogic/AnimationController
@onready var letter_display_manager = $GameLogic/LetterDisplayManager
@onready var timer = $UI/Timer
@onready var p1_letter_container = $"UI/Player1HUD/Letter Container"
@onready var p2_letter_container = $"UI/Player2HUD/Letter Container"
@onready var cameras: Camera2D = $Camera2D

# Optional: assign a PackedScene (e.g., HitBurst.tscn with a GPUParticles2D one_shot) in the Inspector.
@export var hit_burst_scene: PackedScene

var game_started: bool = false
const base_round_time: float = 6.0
var new_round_time: float = base_round_time

func _ready() -> void:
	# Wait one frame for all @onready variables to initialize
	await get_tree().process_frame
	
	# Set up letter display manager with container references
	letter_display_manager.set_containers(p1_letter_container, p2_letter_container)
	
	# Connect RoundController signals
	round_controller.player_key_pressed.connect(_on_player_key_pressed)
	round_controller.round_timer_updated.connect(_on_round_timer_updated)
	round_controller.round_started.connect(_on_round_started)
	round_controller.player1_wins_round.connect(_on_player1_wins_round)
	round_controller.player2_wins_round.connect(_on_player2_wins_round)
	round_controller.both_players_failed.connect(_on_both_players_failed)
	round_controller.both_players_succeed.connect(_on_both_players_succeed)
	
	# Connect PlayerDataManager signals
	player_data_manager.player_damaged.connect(_on_player_damaged)
	player_data_manager.player_died.connect(_on_player_died)
	
	
	AudioManager.play_game_music()
	start_game_sequence()

func _process(delta: float) -> void:
	# Update timer display
	if round_controller.round_active:
		timer.update_time(round_controller.current_time)

func start_game_sequence():
	play_intro()
	#await get_tree().create_timer(3).timeout
	game_started = true
	start_new_round(base_round_time)

func play_intro():
	pass

func start_new_round(round_time: float):
	print("Starting new round with time: ", round_time)
	round_controller.start_round(round_time)
	InputManager.reset_round()
	timer.start_timer(round_time)
	StatsManager.start_new_round()

func _on_round_timer_updated(round_time: float):
	new_round_time = round_time
	print("Round time updated: ", new_round_time)

func _on_round_started(p1_letter_sequence: Array, p2_letter_sequence: Array):
	print("Round started signal received")
	letter_display_manager.spawn_letters(p1_letter_sequence, p2_letter_sequence)

func _on_both_players_succeed():
	print("Both players succeed!")
	animation_controller.play_animation("clash")
	await get_tree().create_timer(0.5).timeout
	cameras.trigger_shake()
	AudioManager.play_sword_clash()
	cameras.trigger_shake()

	# >>> spawn collision particles at the intersection <<<
	_spawn_collision_particles_from_players()

	InputManager.end_round()
	
	await get_tree().create_timer(0.5).timeout
	
	start_new_round(new_round_time)

func _on_both_players_failed():
	print("Both players failed!")
	animation_controller.play_animation("clash")
	await get_tree().create_timer(0.5).timeout
	cameras.trigger_shake()
	AudioManager.play_sword_clash()
	cameras.trigger_shake()

	# >>> spawn collision particles at the intersection <<<
	_spawn_collision_particles_from_players()

	InputManager.end_round()
	
	await get_tree().create_timer(0.5).timeout
	
	start_new_round(new_round_time)

func _on_player1_wins_round():
	print("Player 1 wins round!")
	InputManager.end_round()
	StatsManager.add_round(0)
	
	await get_tree().create_timer(0.5).timeout
	
	player_data_manager.apply_damage(1)

func _on_player2_wins_round():
	print("Player 2 wins round!")
	InputManager.end_round()
	StatsManager.add_round(1)
	
	await get_tree().create_timer(0.5).timeout
	
	player_data_manager.apply_damage(0)

func _on_player_key_pressed(player_id: int, correct: bool):
	if player_id == 0:
		if correct:
			print("P1 correct key")
			letter_display_manager.play_letter_animation(0, true)
		else:
			print("P1 incorrect key")
			letter_display_manager.play_letter_animation(0, false)
	else:
		if correct:
			print("P2 correct key")
			letter_display_manager.play_letter_animation(1, true)
		else:
			print("P2 incorrect key")
			letter_display_manager.play_letter_animation(1, false)

func _on_player_damaged(player_id: int, lives_left: int):
	print("Player ", player_id + 1, " damaged. Lives left: ", lives_left)
	AudioManager.play_player_hit()
	#Update Lives on player HUD
	if player_id == 0:
		#update p1 HUD
		pass
	else:
		#update p2 HUD
		pass
	
	if lives_left > 0:
		start_new_round(new_round_time)

signal game_over(winner_id: int)

func _on_player_died(player_id: int):
	print("Player ", player_id + 1, " died!")
	
	var winner_id = 1 - player_id
	
	var winner_lives = player_data_manager.get_player_lives(winner_id)
	var flawless = (winner_lives == 3)
	
	StatsManager.add_game(winner_id, flawless)
	
	if (winner_id + 1 == 1):
		AudioManager.play_player1_win()
	if (winner_id + 1 == 2):
		AudioManager.play_player2_win()
		
	print("Winner: Player ", winner_id + 1)
	GameManager.set_winner(winner_id)
	GameManager.goto("results")
	
	emit_signal("game_over", winner_id)


# =========================
# Collision particle helpers
# =========================

func _spawn_collision_particles_from_players(intensity: float = 1.0) -> void:
	var p1_pos := _get_player_position(0)
	var p2_pos := _get_player_position(1)
	var pos: Vector2 = (p1_pos + p2_pos) * 0.5
	_spawn_burst_at(pos, intensity)

func _get_player_position(player_id: int) -> Vector2:
	# Prefer a method on PlayerDataManager if available
	if player_data_manager and player_data_manager.has_method("get_player_position"):
		return player_data_manager.get_player_position(player_id)
	# Fallback: use camera center to avoid nulls
	return cameras.global_position

func _spawn_burst_at(pos: Vector2, intensity: float = 1.0) -> void:
	var parent := get_tree().current_scene if get_tree().current_scene != null else self
	var burst_root: Node2D
	
	if hit_burst_scene:
		burst_root = hit_burst_scene.instantiate() as Node2D
	else:
		# Build a compact, randomized one-shot GPUParticles2D at runtime
		burst_root = Node2D.new()
		var p := GPUParticles2D.new()
		p.name = "Burst"
		p.one_shot = true
		p.emitting = false
		p.amount = int(80 * max(0.2, intensity))
		p.lifetime = 0.6
		p.explosiveness = 1.0
		
		var mat := ParticleProcessMaterial.new()
		# Randomize emission center so it doesn't bias to one side
		var theta := randf() * TAU                   # random angle 0..2π
		mat.direction = Vector3(cos(theta), sin(theta), 0.0)
		mat.spread = 180.0                           # half-circle around random direction; change to 360 for full ring look
		
		# Smaller radius (lower velocities)
		mat.initial_velocity_min = 60.0
		mat.initial_velocity_max = 140.0
		mat.gravity = Vector3(0, 0, 0)               # no downward bias
		mat.scale_min = 0.6
		mat.scale_max = 1.2
		
		p.process_material = mat
		burst_root.add_child(p)
	
	burst_root.global_position = pos
	
	# If using a PackedScene for particles, rotate the node randomly to avoid directional bias
	if hit_burst_scene:
		burst_root.rotation = randf() * TAU
	
	parent.add_child(burst_root)
	
	var particles := burst_root.get_node_or_null("Burst") as GPUParticles2D
	if particles == null:
		for c in burst_root.get_children():
			if c is GPUParticles2D:
				particles = c
				break
	
	if particles == null:
		burst_root.queue_free()
		return
	
	# Keep amount sensible with intensity scaling
	particles.amount = int(max(10, particles.amount * max(0.2, intensity)))
	particles.emitting = true
	
	# Auto-cleanup (prefer finished signal if available)
	if particles.has_signal("finished"):
		particles.connect("finished", Callable(burst_root, "queue_free"))
	else:
		await get_tree().create_timer(particles.lifetime + 0.2).timeout
		burst_root.queue_free()
