extends Node

#Signals for GameplayScene
signal player_key_pressed(player_id: int, correct: bool)
signal round_timer_updated(round_time: float)
signal round_started(p1_letter_sequence: Array, p2_letter_sequence: Array)
signal player1_wins_round
signal player2_wins_round
signal both_players_failed
signal both_players_succeed

#Time sequence variables
const p1_letter_dict = {1: "Q", 2: "W", 3: "E", 4: "A", 5: "S", 6: "D"}
const p2_letter_dict = {1: "U", 2: "I", 3: "O", 4: "J", 5: "K", 6: "L"}
const p1_reversed_dict = {"Q": 1, "W": 2, "E": 3, "A": 4, "S": 5, "D": 6}
const p2_reversed_dict = {"U": 1, "I": 2, "O": 3, "J": 4, "K": 5, "L": 6}
var p1_letter_sequence = []
var p2_letter_sequence = []

#round time dependencies
var round_active: bool = false
var round_time: float
var current_time: float
var time_decrease_percent: float = 0.125

var player_completed: Array = [false, false]
var player_failed: Array = [false, false]

func _ready() -> void:
	InputManager.handle_p1_input.connect(handle_p1_input)
	InputManager.handle_p2_input.connect(handle_p2_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not round_active:
		return
	
	# Update timer
	current_time -= delta
	
	# Check for completion
	if p1_letter_sequence.is_empty():
		player_completed[0] = true
	if p2_letter_sequence.is_empty():
		player_completed[1] = true
	
	# Check if both players finished
	if player_completed[0] and player_completed[1]:
		_evaluate_round()
		return
	
	# Check for timeout
	if current_time <= 0:
		current_time = 0.0
		_handle_timeout()

func load_sequences() -> void:
	randomize()
	for i in 3:
		var num: int = randi_range(1, 6)
		p1_letter_sequence.append(p1_letter_dict[num])
		p2_letter_sequence.append(p2_letter_dict[num])
	print("P1 Sequence: ", p1_letter_sequence)
	print("P2 Sequence: ", p2_letter_sequence)

func handle_p1_input(key: String):
	if not round_active or p1_letter_sequence.is_empty():
		return
	
	var popped = p1_letter_sequence.pop_front()
	
	if popped == key:
		emit_signal("player_key_pressed", 0, true)
		print("P1 Valid")
	else:
		emit_signal("player_key_pressed", 0, false)
		player_failed[0] = true
		print("P1 Invalid - Expected: ", popped, " Got: ", key)

func handle_p2_input(key: String):
	if not round_active or p2_letter_sequence.is_empty():
		return
	
	var popped = p2_letter_sequence.pop_front()
	
	if popped == key:
		emit_signal("player_key_pressed", 1, true)
		print("P2 Valid")
	else:
		emit_signal("player_key_pressed", 1, false)
		player_failed[1] = true
		print("P2 Invalid - Expected: ", popped, " Got: ", key)

func _handle_timeout():
	print("Round timeout!")
	_evaluate_round()

func start_round(round_timer: float):
	# Reset state for new round
	round_active = true
	round_time = round_timer
	current_time = round_time
	player_completed = [false, false]
	player_failed = [false, false]
	
	# Clear any leftover sequences
	p1_letter_sequence.clear()
	p2_letter_sequence.clear()
	
	# Load new sequences and start
	load_sequences()
	emit_signal("round_started", p1_letter_sequence, p2_letter_sequence)
	print("Round started - Time: ", round_time)

func end_round():
	round_active = false
	p1_letter_sequence.clear()
	p2_letter_sequence.clear()

func _evaluate_round():
	if not round_active:
		return
	
	end_round()
	
	var p1_success = player_completed[0] and not player_failed[0]
	var p2_success = player_completed[1] and not player_failed[1]
	
	print("Evaluating round - P1 Success: ", p1_success, " P2 Success: ", p2_success)
	
	#Case 1: Both Fail or Timeout
	if not p1_success and not p2_success:
		check_timer()
		emit_signal("round_timer_updated", round_time)
		emit_signal("both_players_failed")
		print("Both players failed")
	
	#Case 2: Player 1 wins
	elif p1_success and not p2_success:
		emit_signal("player1_wins_round")
		print("Player 1 wins round")
	
	#Case 3: Player 2 wins
	elif p2_success and not p1_success:
		emit_signal("player2_wins_round")
		print("Player 2 wins round")
	
	#Case 4: Both Succeed
	elif p1_success and p2_success:
		increase_round_difficulty()
		emit_signal("round_timer_updated", round_time)
		emit_signal("both_players_succeed")
		print("Both players succeed - New time: ", round_time)

func check_timer():
	if round_time < 2.0:
		round_time = 2.0

func increase_round_difficulty():
	round_time *= (1 - time_decrease_percent)
	if round_time < 2.0:
		round_time = 2.0
