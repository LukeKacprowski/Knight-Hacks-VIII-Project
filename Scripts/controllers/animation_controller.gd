extends Node

@onready var animated_sprite = get_node("../../GameplayAnimatedSprite")

func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_gameplay_animated_sprite_animation_finished)
	if animated_sprite:
		play_animation("idle")

func play_animation(animation_name: String):
	if animated_sprite:
		animated_sprite.play(animation_name)


func _on_gameplay_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation != "idle":
		play_animation("idle")
