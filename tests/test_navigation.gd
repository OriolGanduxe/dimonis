# TestRun.gd
# Temporary test script to verify the game runs correctly headlessly
extends Node

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	print("=== TEST: NavigationManager check ===")
	print("Rooms loaded: ", NavigationManager.rooms_data.size())
	print("Current room ID: ", NavigationManager.current_room_id)
	print("Has 'tower': ", NavigationManager.rooms_data.has("tower"))
	print("Has 'library': ", NavigationManager.rooms_data.has("library"))
	print("Has 'laboratory': ", NavigationManager.rooms_data.has("laboratory"))
	
	if NavigationManager.rooms_data.has("tower"):
		var tower = NavigationManager.rooms_data["tower"]
		print("Tower background: ", tower.get("background", "MISSING"))
		var hotspots = tower.get("hotspots", [])
		print("Tower hotspots: ", hotspots.size())
	else:
		print("ERROR: Tower not loaded!")
	
	# Try loading a background
	var bg_path = "res://assets/backgrounds/tower/tower_bg.jpg"
	var texture = ResourceLoader.load(bg_path) as Texture2D
	if texture:
		print("Background loaded: OK (", texture.get_size().x, "x", texture.get_size().y, ")")
	else:
		print("ERROR: Background NOT loaded!")
	
	# Try loading the tower scene
	var scene = ResourceLoader.load("res://scenes/rooms/tower.tscn") as PackedScene
	if scene:
		print("Tower scene: OK")
	else:
		print("ERROR: Tower scene NOT loaded!")
	
	get_tree().quit(0)