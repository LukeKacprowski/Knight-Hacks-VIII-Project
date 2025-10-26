extends Node

@onready var player_data_manager = $GameLogic/PlayerDataManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
