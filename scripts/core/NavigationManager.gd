# NavigationManager.gd
# Core layer - Gestiona la navegació entre estances (Clean Architecture)
# Singletons/Autoload per la jerarquia global del joc
extends Node

signal room_changed(room_id: String)
signal transition_started()
signal transition_finished()

const TRANSITION_DURATION: float = 1.0

var current_room_id: String = ""
var rooms_data: Dictionary = {}
var _transition_in_progress: bool = false


func _ready() -> void:
	_load_rooms_data()


func _load_rooms_data() -> void:
	var file: FileAccess = FileAccess.open("res://data/rooms/rooms.json", FileAccess.READ)
	if file == null:
		push_error("NavigationManager: No s'ha pogut carregar rooms.json")
		return

	var json_str: String = file.get_as_text()
	var json_parser: JSON = JSON.new()
	var parse_result: int = json_parser.parse(json_str)
	
	if parse_result != OK:
		push_error("NavigationManager: Error parsejant rooms.json: ", parse_result)
		return
	
	var data: Dictionary = json_parser.data
	if data.is_empty() or not data.has("rooms"):
		push_error("NavigationManager: rooms.json no té array 'rooms'")
		return
	
	var rooms_list: Array = data["rooms"]
	for room in rooms_list:
		var room_dict: Dictionary = room
		var room_id: String = room_dict.get("id", "")
		if not room_id.is_empty():
			rooms_data[room_id] = room_dict


func get_room_data(room_id: String) -> Dictionary:
	return rooms_data.get(room_id, {})


func navigate_to(room_id: String) -> void:
	if _transition_in_progress:
		return
	if not rooms_data.has(room_id):
		push_error("NavigationManager: Estança desconeguda: ", room_id)
		return
	if room_id == current_room_id:
		return
	
	_transition_in_progress = true
	transition_started.emit()
	
	var room_data: Dictionary = rooms_data.get(room_id, {})
	_transition_to_scene(room_data)


func _transition_to_scene(room_data: Dictionary) -> void:
	# Create the fade overlay
	var fade_overlay: ColorRect = ColorRect.new()
	fade_overlay.name = "TransitionFade"
	fade_overlay.color = Color.BLACK
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Must be deferred to avoid "busy setting up children" errors during startup
	get_tree().root.call_deferred(&"add_child", fade_overlay)
	fade_overlay.modulate = Color(1, 1, 1, 0)
	
	# Wait one frame for the deferred add to complete
	await get_tree().process_frame
	
	# Fade to black
	var fade_in_tween: Tween = get_tree().create_tween().set_parallel(false)
	fade_in_tween.tween_property(fade_overlay, "modulate:a", 1.0, TRANSITION_DURATION * 0.4)
	await fade_in_tween.finished
	
	# Change scene
	var room_id: String = room_data.get("id", "")
	current_room_id = room_id
	
	var success: bool = _load_room_scene(room_data)
	if not success:
		push_error("NavigationManager: No s'ha pogut carregar l'escena: ", room_id)
		_transition_in_progress = false
		return
	
	# Short pause to let the scene initialize
	await get_tree().create_timer(0.1).timeout
	
	# Fade from black
	var fade_out_tween: Tween = get_tree().create_tween().set_parallel(false)
	fade_out_tween.tween_property(fade_overlay, "modulate:a", 0.0, TRANSITION_DURATION * 0.6)
	await fade_out_tween.finished
	
	fade_overlay.queue_free()
	
	_transition_in_progress = false
	room_changed.emit(room_id)
	transition_finished.emit()


func _load_room_scene(room_data: Dictionary) -> bool:
	var room_id: String = room_data.get("id", "")
	var scene_path: String = "res://scenes/rooms/%s.tscn" % room_id
	var room_scene: PackedScene = ResourceLoader.load(scene_path) as PackedScene
	
	if room_scene == null:
		push_error("NavigationManager: No s'ha trobat l'escena: ", scene_path)
		# Fallback: Try to load from scenes/tower/
		if room_id == "tower":
			var alt_scene: PackedScene = ResourceLoader.load("res://scenes/tower/Tower.tscn") as PackedScene
			if alt_scene != null:
				room_scene = alt_scene
		if room_scene == null:
			return false
	
	var instance: Node2D = room_scene.instantiate() as Node2D
	if instance == null:
		push_error("NavigationManager: L'escena no és Node2D: ", scene_path)
		return false
	
	# Remove current room scene
	var current_scene: Node = get_tree().current_scene
	if current_scene != null:
		current_scene.queue_free()
	
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance
	
	return true


# Helper to get all hotspots for current room
func get_current_room_hotspots() -> Array:
	var data: Dictionary = get_room_data(current_room_id)
	return data.get("hotspots", [])


# Helper to get hotspot data by ID
func get_hotspot_data(hotspot_id: String) -> Dictionary:
	var hotspots: Array = get_current_room_hotspots()
	for hs in hotspots:
		var hs_dict: Dictionary = hs
		if hs_dict.get("id", "") == hotspot_id:
			return hs_dict
	return {}