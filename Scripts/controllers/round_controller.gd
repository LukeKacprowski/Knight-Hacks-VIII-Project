extends Node

#Signals for GameplayScene
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

#Result Cases
var both_players_finish: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not round_active:
		return
	
	if p1_letter_sequence.is_empty():
		player_completed[0] = true
	if p2_letter_sequence.is_empty():
		player_completed[1] = true
	if player_completed[0] == true and player_completed[1] == true:
		both_players_finish = true
		_evaluate_round()
	
	current_time -= delta
	
	if current_time <= 0:
		current_time = 0.0
		_handle_timeout()

func load_sequences() -> void:
	for i in 3:
		var num: int = randi_range(1, 6)
		p1_letter_sequence.append(p1_letter_dict[num])
		p2_letter_sequence.append(p2_letter_dict[num])

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var key = OS.get_keycode_string(event.keycode).to_upper()
	
		if key in p1_reversed_dict:
			handle_p1_input(key)
		elif key in p2_reversed_dict:
			handle_p2_input(key)

func handle_p1_input(key: String):
	if p1_letter_sequence.is_empty():
		return
	
	var popped = p1_letter_sequence.pop_back()
	
	if popped == key:
		return
	else:
		player_failed[0] = true
		return

func handle_p2_input(key: String):
	if p2_letter_sequence.is_empty():
		return
	
	var popped = p2_letter_sequence.pop_back()
	
	if popped == key:
		return 
	else:
		player_failed[1] = true
		return

func _handle_timeout():
	_evaluate_round()

func start_round(round_timer: float):
	round_active = true
	round_time = round_timer
	current_time = round_time
	load_sequences()
	emit_signal("round_started", p1_letter_sequence, p2_letter_sequence)

func end_round():
	round_active = false

func _evaluate_round():
	if not round_active:
		return
	
	end_round()
	
	var _p1_success = player_completed[0] and not player_failed[0]
	var _p2_success = player_completed[1] and not player_failed[1]
	
	#Case 1: Timeout or Both Fail
	if (player_completed[0] == false && player_completed[1] == false) || (_p1_success == false && _p2_success == false):
		check_timer()
		emit_signal("round_timer_updated", round_time)
		emit_signal("both_players_failed")
	
	#Case 2: Player 1 wins
	elif _p1_success == true && _p2_success == false:
		emit_signal("player1_wins_round")
	
	#Case 3: Player 2 wins
	elif _p2_success == true && _p1_success == false:
		emit_signal("player2_wins_round")
	
	#Case 4: Both Succeed
	elif _p1_success == true && _p2_success == true:
		increase_round_difficulty()
		emit_signal("round_timer_updated", round_time)
		emit_signal("both_players_succeed")

func check_timer():
	if round_time < 2.0:
		round_time = 2.0

func increase_round_difficulty():
	round_time *= (1 - time_decrease_percent)
