extends Control

@onready var letter_sprite = $LetterSprite

var letter_key: String = ""
var is_correct: bool = false
var is_completed: bool = false

signal animation_finished

func _ready():
	pass
	
func setup(key: String):
	letter_key = key.to_upper()
	is_correct = false
	is_completed = false
	
	# Load the sprite frames for this letter
	var sprite_frames_path = "res://Assets/ui/letters/Letter%s.tres" % letter_key
	
	if ResourceLoader.exists(sprite_frames_path):
		var sprite_frames = load(sprite_frames_path)
		letter_sprite.sprite_frames = sprite_frames
		letter_sprite.play("idle")
	else:
		push_error("Could not find sprite frames at: " + sprite_frames_path)
	
func play_correct():
	if is_completed:
		return
	
	is_correct = true
	is_completed = true
	
	if letter_sprite.sprite_frames and letter_sprite.sprite_frames.has_animation("correct"):
		letter_sprite.play("correct")
		await letter_sprite.animation_finished
	
	emit_signal("animation_finished")

func play_incorrect():
	if is_completed:
		return
	
	is_correct = false
	is_completed = true
	
	if letter_sprite.sprite_frames and letter_sprite.sprite_frames.has_animation("incorrect"):
		letter_sprite.play("incorrect")
		await letter_sprite.animation_finished
	
	emit_signal("animation_finished")

func reset():
	is_correct = false
	is_completed = false
	
	if letter_sprite and letter_sprite.sprite_frames:
		letter_sprite.play("idle")
