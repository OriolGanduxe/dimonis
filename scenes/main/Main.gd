# Main.gd
# Presentation layer - Punt d'entrada del joc
extends Node2D


func _ready() -> void:
	# Auto-setup: wait for NavigationManager to be ready
	# then navigate to the first room
	NavigationManager.room_changed.connect(_on_loaded)
	NavigationManager.navigate_to("tower")


func _on_loaded(_room_id: String) -> void:
	# Room loaded - we can now hide/remove the main scene if needed
	# For now, the NavigationManager replaces current_scene so 
	# Main.tscn is automatically replaced
	pass