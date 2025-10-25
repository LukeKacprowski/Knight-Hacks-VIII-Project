@tool
extends Node

func _run():
	var keys = ["Q", "W", "E", "A", "S", "D", "U", "I", "O", "J", "K", "L"]
	
	print("=== Starting Sprite Frame Generation ===")
	
	for key in keys:
		var sheet_path = "res://Assets/ui/letters/Letter%s-Sheet.png" % key
		
		print("Looking for: ", sheet_path)
		
		# Check if file exists
		if not ResourceLoader.exists(sheet_path):
			push_error("File not found: " + sheet_path)
			continue
		
		var texture = load(sheet_path)
		
		if texture == null:
			push_error("Failed to load texture: " + sheet_path)
			continue
		
		print("Loaded texture: ", sheet_path, " Size: ", texture.get_width(), "x", texture.get_height())
		
		var frame_width = texture.get_width() / 4
		var frame_height = texture.get_height()
		
		var sprite_frames = SpriteFrames.new()
		
		# Create idle animation
		sprite_frames.add_animation("idle")
		sprite_frames.set_animation_loop("idle", true)
		sprite_frames.set_animation_speed("idle", 1)
		
		var idle_atlas = AtlasTexture.new()
		idle_atlas.atlas = texture
		idle_atlas.region = Rect2(0 * frame_width, 0, frame_width, frame_height)
		sprite_frames.add_frame("idle", idle_atlas)
		
		# Create correct animation
		sprite_frames.add_animation("correct")
		sprite_frames.set_animation_loop("correct", false)
		sprite_frames.set_animation_speed("correct", 10)
		
		var correct_atlas = AtlasTexture.new()
		correct_atlas.atlas = texture
		correct_atlas.region = Rect2(1 * frame_width, 0, frame_width, frame_height)
		sprite_frames.add_frame("correct", correct_atlas)
		
		# Create incorrect animation
		sprite_frames.add_animation("incorrect")
		sprite_frames.set_animation_loop("incorrect", false)
		sprite_frames.set_animation_speed("incorrect", 10)
		
		var incorrect_atlas = AtlasTexture.new()
		incorrect_atlas.atlas = texture
		incorrect_atlas.region = Rect2(3 * frame_width, 0, frame_width, frame_height)
		sprite_frames.add_frame("incorrect", incorrect_atlas)
		
		# Save as .tres file
		var save_path = "res://Assets/ui/letters/Letter%s.tres" % key
		var result = ResourceSaver.save(sprite_frames, save_path)
		
		if result == OK:
			print("✓ Successfully saved: ", save_path)
		else:
			push_error("Failed to save: " + save_path + " Error code: " + str(result))
	
	print("=== Generation Complete ===")
	print("Files should be at: ", ProjectSettings.globalize_path("res://Assets/ui/letters/"))
	
	# Force filesystem scan
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
