extends Node
signal screen_changed(scene_name: String)

# creating a dictrionary for the file paths 
const SCENE_PATHS := {
	"main":        "res://Scenes/main.tscn",
	"main_menu":   "res://Scenes/main_menu.tscn",
	"how_to_play": "res://Scenes/how_to_play.tscn",
	"how_to_play2": "res://Scenes/how_to_play2.tscn",
	"gameplay":    "res://Scenes/gameplay.tscn",
	"results": "res://Scenes/results.tscn",
}

#buffer for global handoff
var _pending_winner: int = -1
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
	
	# after the new root, gather if need
	var new_root: Node = get_tree().current_scene
	
	# ifgame play loaded, try to connect to its game over siganl 
	if scene_name == "gameplay" and new_root:
		_hook_gameplay_signal(new_root)
	
	# we load results for the winner that is waiting 
	if scene_name == "results" and new_root and _pending_winner != -1:
		call_deferred("_deliver_winner_to_results", new_root, _pending_winner)
	
func _hook_gameplay_signal(root: Node) -> void:
	if root.has_signal("game_over"):
		if !root.is_connected("game_over", Callable(self, "_on_game_over")):
			root.connect("game_over", Callable(self, "_on_game_over"),CONNECT_ONE_SHOT) 
		return
	if root.has_node("GameLogic"):
		var logic: Node = root.get_node("GameLogic")
		var emitter: Node = _find_node_with_signal(logic, "game_over")
		if emitter:
			if !emitter.is_connected("game_over", Callable(self, "_on_game_over")):
				emitter.connect("game_over", Callable(self, "_on_game_over"), CONNECT_ONE_SHOT)
			return
			
	var any_emitter: Node = _find_node_with_signal(root, "game_over")
	if any_emitter and !any_emitter.is_connected("game_over", Callable(self, "_on_game_over")):
		any_emitter.connect("game_over", Callable(self, "_on_game_over"), CONNECT_ONE_SHOT)
		# DFS search for node exposing a specific signal
func _find_node_with_signal(start: Node, signal_name: String) -> Node:
	if start.has_signal(signal_name):
		return start
	for child in start.get_children():
		if child is Node:
			var found: Node = _find_node_with_signal(child, signal_name)
			if found:
				return found
	return null

# Receives winner id from gameplay, then moves to results
func _on_game_over(winner_id: int) -> void:
	_pending_winner = winner_id
	goto("results")

 

# Called after results is live; hands off the winner and clears buffer
func _deliver_winner_to_results(results_root: Node, winner_id: int) -> void:
	if results_root and results_root.has_method("set_winner"):
		results_root.call("set_winner", winner_id)
	_pending_winner = -1
