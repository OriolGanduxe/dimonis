class_name BookResource
extends Resource

## Recurs que defineix l'estructura d'un llibre seguint el schema definit al GDD
## Implementa el sistema de llibres amb informació gradualment revelada

@export var book_id: String = ""
@export var title: String = ""
@export var author: String = ""
@export var year_written: int = 0
@export var reliability_level: float = 1.0  # 0.0-1.0
@export var category: String = ""

@export_group("Physical Properties")
@export var condition: String = "good"  # excellent|good|damaged|fragmentary
@export var material: String = "paper"  # parchment|paper|vellum
@export var binding: String = "leather"  # leather|wooden|damaged
@export var has_illustrations: bool = false
@export var pages: int = 100

@export_group("Access Requirements")
@export var required_tower_level: int = 0  # 0-3
@export var prerequisite_knowledge: Array[String] = []
@export var special_conditions: String = ""

@export_group("Content")
@export var chapters: Array[BookChapterResource] = []
@export var cross_references: Array[String] = []  # IDs de altres llibres
@export var contradictions: Array[BookContradictionResource] = []
@export var hidden_information: Array[BookHiddenInfoResource] = []

## Estat de descobriment del jugador (no es serialitza amb el recurs base)
var discovery_state: String = "closed"  # closed|browsed|studied|mastered
var player_notes: Array[String] = []
var marked_passages: Array[String] = []
var times_consulted: int = 0

func get_filtered_content_for_player_level(access_level: int, knowledge_state: Dictionary) -> Dictionary:
	"""Retorna el contingut del llibre filtrat segons el nivell d'accés del jugador"""
	var filtered_content = {
		"title": title if access_level > 0 else "???",
		"author": author if access_level > 1 else "Autor desconegut",
		"available_chapters": []
	}
	
	# Filtra capítols segons prerequisits
	for chapter in chapters:
		if chapter.meets_requirements(knowledge_state):
			filtered_content.available_chapters.append(chapter)
	
	return filtered_content

func calculate_reliability_for_section(section_id: String) -> float:
	"""Calcula la fiabilitat d'una secció específica basada en cross-references"""
	# Implementació del sistema de fiabilitat cross-referencial
	return reliability_level

func get_cross_references_discovered() -> Array[String]:
	"""Retorna les referències creuades que el jugador ha descobert"""
	# Implementar lògica de descobriment gradual
	return cross_references

func has_contradiction_with(other_book_id: String, topic: String) -> bool:
	"""Comprova si aquest llibre té contradiccions amb un altre llibre sobre un tema específic"""
	for contradiction in contradictions:
		if contradiction.involves_book(other_book_id) and contradiction.topic == topic:
			return true
	return false

func reveal_hidden_information(method: String, player_skill: Dictionary) -> Array[BookHiddenInfoResource]:
	"""Intenta revelar informació amagada basada en el mètode i habilitats del jugador"""
	var revealed = []
	for hidden_info in hidden_information:
		if hidden_info.can_be_discovered(method, player_skill):
			revealed.append(hidden_info)
	return revealed