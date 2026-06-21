class_name BookSectionResource  
extends Resource

## Representa una secció dins d'un capítol de llibre

@export var section_id: String = ""
@export var title: String = ""
@export var main_text: String = ""
@export var access_prerequisites: Array[String] = []

@export_group("Additional Content")
@export var margin_notes: Array[BookMarginNoteResource] = []
@export var illustrations: Array[BookIllustrationResource] = []

func is_accessible(knowledge_state: Dictionary) -> bool:
	"""Determina si aquesta secció és accessible per al jugador actual"""
	for prerequisite in access_prerequisites:
		if not knowledge_state.has(prerequisite):
			return false
	return true

func get_filtered_text_for_player(knowledge_level: int) -> String:
	"""Retorna el text filtrat segons el nivell de coneixement del jugador"""
	# Implementar sistema de revelació gradual de text
	return main_text

func get_available_margin_notes(discovery_method: String, player_skill: Dictionary) -> Array[BookMarginNoteResource]:
	"""Retorna les notes marginals que el jugador pot descobrir amb el mètode especificat"""
	var available = []
	for note in margin_notes:
		if note.can_be_discovered(discovery_method, player_skill):
			available.append(note)
	return available