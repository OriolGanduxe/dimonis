# Main.gd
# Presentation layer - Punt d'entrada del joc
extends Node2D


func _ready() -> void:
	# Auto-setup: wait for NavigationManager to be ready
	# then navigate to the first room
	NavigationManager.room_changed.connect(_on_loaded)
	NavigationManager.navigate_to("tower")
	
	# Run diagnostics after a short delay
	await get_tree().create_timer(1.0).timeout
	_diagnostics()


func _diagnostics() -> void:
	print("=== NAVIGATION DIAGNOSTICS ===")
	print("Current room: ", NavigationManager.current_room_id)
	var tower_data = NavigationManager.get_room_data("tower")
	print("Tower data exists: ", not tower_data.is_empty())
	if not tower_data.is_empty():
		print("Tower bg: ", tower_data.get("background", "MISSING"))
		print("Hotspots: ", tower_data.get("hotspots", []).size())
	
	var lib_data = NavigationManager.get_room_data("library")
	print("Library data exists: ", not lib_data.is_empty())
	
	var lab_data = NavigationManager.get_room_data("laboratory")
	print("Laboratory data exists: ", not lab_data.is_empty())
	
	# Try loading background directly
	var test_bg = ResourceLoader.load("res://assets/backgrounds/tower/tower_bg.jpg")
	print("Background loadable: ", test_bg != null)
	
	# Try loading room scenes
	var tower_scene = ResourceLoader.load("res://scenes/rooms/tower.tscn") as PackedScene
	print("Tower scene loadable: ", tower_scene != null)
	
	var lib_scene = ResourceLoader.load("res://scenes/rooms/library.tscn") as PackedScene
	print("Library scene loadable: ", lib_scene != null)


func _on_loaded(_room_id: String) -> void:
	pass
	# For now, the NavigationManager replaces current_scene so 
	# Main.tscn is automatically replaced
	pass