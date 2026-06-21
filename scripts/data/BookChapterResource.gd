class_name BookChapterResource
extends Resource

## Representa un capítol individual dins d'un BookResource

@export var chapter_id: String = ""
@export var title: String = ""
@export var content_type: String = "theoretical"  # theoretical|practical|reference|narrative

@export_group("Content")
@export var sections: Array[BookSectionResource] = []
@export var prerequisites: Array[String] = []  # Coneixement requerit per accedir

func meets_requirements(knowledge_state: Dictionary) -> bool:
	"""Comprova si el jugador compleix els requisits per accedir a aquest capítol"""
	for prerequisite in prerequisites:
		if not knowledge_state.has(prerequisite):
			return false
	return true

func get_available_sections_for_player(knowledge_state: Dictionary) -> Array[BookSectionResource]:
	"""Retorna les seccions disponibles per al nivell actual del jugador"""
	var available = []
	for section in sections:
		if section.is_accessible(knowledge_state):
			available.append(section)
	return available