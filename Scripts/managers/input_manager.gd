extends Node

signal handle_p1_input(key: String)
signal handle_p2_input(key: String)

const p1_keys = ["Q", "W", "E", "A", "S", "D"]
const p2_keys = ["U", "I", "O", "J", "K", "L"]

var round_active: bool = false

func _input(event):
	if not round_active:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		var key = OS.get_keycode_string(event.keycode).to_upper()
		if key.to_upper() in p1_keys:
			emit_signal("handle_p1_input", key)
		elif key.to_upper() in p2_keys:
			emit_signal("handle_p2_input", key)

func reset_round():
	round_active = true

func end_round():
	round_active = false
