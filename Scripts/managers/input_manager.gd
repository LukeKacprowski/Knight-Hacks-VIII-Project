extends Node

signal handle_p1_input(key: String)
signal handle_p2_input(key: String)

const p1_keys = ["q", "w", "e", "a", "s", "d"]
const p2_keys = ["u", "i", "o", "j", "k", "l"]

var round_active: bool = false

func _input(event):
	if not round_active:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		var key = OS.get_keycode_string(event.keycode).to_upper()
	
		if key in p1_keys:
			emit_signal("handle_p1_input", key)
		elif key in p2_keys:
			emit_signal("handle_p2_input", key)

func reset_round():
	round_active = true

func end_round():
	round_active = false
