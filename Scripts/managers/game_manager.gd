extends Node
signal screen_changed(scene_name: String)

# creating a dictrionary for the file paths 
const SCENE_PATHS := {
	"main":        "res://Scenes/main.tscn",
	"main_menu":   "res://Scenes/main_menu.tscn",
	"how_to_play": "res://Scenes/how_to_play.tscn",
	"how_to_play2": "res://Scenes/how_to_play2.tscn",
	"gameplay":    "res://Scenes/gameplay.tscn",
}

# This function swichtes to a new scene 
func goto(scene_name: String, load_async := false) -> void:
	if !SCENE_PATHS.has(scene_name):
		push_warning("Unknown screen: %s" % scene_name)
		return
	var scene_path: String = SCENE_PATHS[scene_name]
	if load_async:
		await _async_change(scene_path, scene_name)
	else:
		_sync_change(scene_path, scene_name)

# Relods the curent scnene that is active 
func reload(load_async := false) -> void:
	var current := get_tree().current_scene
	if current == null:
		return
	var scene_path := current.scene_file_path
	if scene_path == "":
		return
	if load_async:
		await _async_change(scene_path, current.name)
	else:
		_sync_change(scene_path, current.name)

# loads a new scene right away 
func _sync_change(scene_path: String, scene_name: String) -> void:
	var loaded_packed_scene := load(scene_path)
	if !(loaded_packed_scene is PackedScene):
		push_warning("Not a scene: %s" % scene_path)
		return
	_swap_scene(loaded_packed_scene, scene_name)

# Loads a new scene in the background 
func _async_change(scene_path: String, scene_name: String) -> void:
	var load_request_result := ResourceLoader.load_threaded_request(scene_path)
	if load_request_result != OK:
		push_warning("Threaded load failed: %s" % scene_path)
		return

	while true:
		var load_status := ResourceLoader.load_threaded_get_status(scene_path)

		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			var loaded_resource := ResourceLoader.load_threaded_get(scene_path)
			if loaded_resource is PackedScene:
				_swap_scene(loaded_resource, scene_name)
			break
		elif load_status == ResourceLoader.THREAD_LOAD_FAILED:
			push_warning("Async load failed: %s" % scene_path)
			break

		await get_tree().process_frame

#It removes the old scene with a new one 
func _swap_scene(packed_scene: PackedScene, scene_name: String) -> void:
	var error_code := get_tree().change_scene_to_packed(packed_scene)
	if error_code != OK:
		push_warning("Failed to change scene to: %s" % scene_name)
		return
	emit_signal("screen_changed", scene_name)
