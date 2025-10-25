extends Node

# Preload the LetterDisplay scene
var letter_display_scene = preload("res://Scenes/ui/LetterDisplay.tscn")

# References to the HUD containers - will be set from gameplay_controller
var p1_letter_container: Node = null
var p2_letter_container: Node = null

# Store current letter displays
var p1_letter_displays: Array = []
var p2_letter_displays: Array = []

func _ready():
	pass

func set_containers(p1_container, p2_container):
	p1_letter_container = p1_container
	p2_letter_container = p2_container
	print("Letter containers set successfully")

func spawn_letters(p1_sequence: Array, p2_sequence: Array):
	# Make sure containers are set
	if not p1_letter_container or not p2_letter_container:
		push_error("Letter containers not set!")
		return
	
	print("Spawning letters - P1: ", p1_sequence, " P2: ", p2_sequence)
	
	# Clear existing letters
	clear_letters()
	
	# Spawn P1 letters
	for letter_key in p1_sequence:
		var letter_display = letter_display_scene.instantiate()
		p1_letter_container.add_child(letter_display)
		letter_display.setup(letter_key)
		p1_letter_displays.append(letter_display)
		print("Spawned P1 letter: ", letter_key)
	
	# Spawn P2 letters
	for letter_key in p2_sequence:
		var letter_display = letter_display_scene.instantiate()
		p2_letter_container.add_child(letter_display)
		letter_display.setup(letter_key)
		p2_letter_displays.append(letter_display)
		print("Spawned P2 letter: ", letter_key)
	
	print("Total spawned - P1: ", p1_letter_displays.size(), " P2: ", p2_letter_displays.size())

func clear_letters():
	# Clear P1 letters
	for display in p1_letter_displays:
		if display and is_instance_valid(display):
			display.queue_free()
	p1_letter_displays.clear()
	
	# Clear P2 letters
	for display in p2_letter_displays:
		if display and is_instance_valid(display):
			display.queue_free()
	p2_letter_displays.clear()

func play_letter_animation(player_id: int, correct: bool):
	var displays = p1_letter_displays if player_id == 0 else p2_letter_displays
	
	# Find the first incomplete letter
	for display in displays:
		if not display.is_completed:
			if correct:
				display.play_correct()
			else:
				display.play_incorrect()
			return

func reset_all_letters():
	for display in p1_letter_displays:
		if display and is_instance_valid(display):
			display.reset()
	
	for display in p2_letter_displays:
		if display and is_instance_valid(display):
			display.reset()
