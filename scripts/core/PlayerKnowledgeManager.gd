class_name PlayerKnowledgeManager
extends RefCounted

## Gestiona el coneixement del jugador - implementa el sistema de descobriment gradual
## Layer Core de Clean Architecture

signal object_identification_updated(object_id: String, old_state: String, new_state: String)
signal skill_improved(skill_name: String, old_level: int, new_level: int)
signal compendium_entry_added(entry_id: String)
signal property_confirmed(object_id: String, property_name: String)

var compendium_entries: Dictionary = {}  # object_id -> CompendiumEntryResource
var player_skills: Dictionary = {}
var discovery_history: Array[Dictionary] = []

func initialize_from_save(save_data: SaveGameResource) -> void:
	"""Inicialitza el manager amb dades d'un save nou"""
	player_skills = save_data.get_skill_dictionary()
	
	# Carregar entrades del compendi
	compendium_entries.clear()
	for entry in save_data.compendium_entries:
		compendium_entries[entry.object_id] = entry
	
	print("PlayerKnowledgeManager inicialitzat amb %d entrades" % compendium_entries.size())

func load_from_save(save_data: SaveGameResource) -> bool:
	"""Carrega estat des d'un save existent"""
	try:
		initialize_from_save(save_data)
		return true
	except:
		push_error("Error carregant PlayerKnowledgeManager des del save")
		return false

func update_save_data(save_data: SaveGameResource) -> void:
	"""Actualitza el save amb l'estat actual"""
	# Actualitzar habilitats
	save_data.identification_skill = player_skills.get("identification_skill", 0)
	save_data.experimentation_skill = player_skills.get("experimentation_skill", 0)
	save_data.research_skill = player_skills.get("research_skill", 0)
	save_data.communication_skill = player_skills.get("communication_skill", 0)
	save_data.synthesis_skill = player_skills.get("synthesis_skill", 0)
	
	# Actualitzar entrades del compendi
	save_data.compendium_entries = compendium_entries.values()

## Gestió del Compendi

func discover_object(object_id: String, location: String, circumstances: String, initial_description: String) -> CompendiumEntryResource:
	"""Registra el descobriment d'un nou objecte"""
	if compendium_entries.has(object_id):
		push_warning("Objecte %s ja descobert prèviament" % object_id)
		return compendium_entries[object_id]
	
	var entry = CompendiumEntryResource.new()
	entry.entry_id = "entry_%d" % Time.get_ticks_msec()
	entry.object_id = object_id
	entry.date_found = Time.get_datetime_string_from_system()
	entry.location_found = location
	entry.circumstances = circumstances
	entry.initial_description = initial_description
	entry.current_state = "unknown"
	entry.confidence_level = 0.0
	entry.player_assigned_name = "Objecte desconegut"
	
	compendium_entries[object_id] = entry
	
	# Millorar habilitat d'identificació
	improve_skill("identification_skill", 1)
	
	compendium_entry_added.emit(entry.entry_id)
	print("Nou objecte descobert: %s a %s" % [object_id, location])
	
	return entry

func get_compendium_entry(object_id: String) -> CompendiumEntryResource:
	"""Recupera una entrada del compendi"""
	return compendium_entries.get(object_id, null)

func has_compendium_entry(object_id: String) -> bool:
	"""Comprova si existeix una entrada per a l'objecte"""
	return compendium_entries.has(object_id)

func get_all_entries() -> Array[CompendiumEntryResource]:
	"""Retorna totes les entrades del compendi"""
	return compendium_entries.values()

func get_entries_by_state(state: String) -> Array[CompendiumEntryResource]:
	"""Retorna entrades filtrades per estat d'identificació"""
	var filtered = []
	for entry in compendium_entries.values():
		if entry.current_state == state:
			filtered.append(entry)
	return filtered

func get_entries_by_confidence_range(min_confidence: float, max_confidence: float) -> Array[CompendiumEntryResource]:
	"""Retorna entrades dins un rang de confiança"""
	var filtered = []
	for entry in compendium_entries.values():
		if entry.confidence_level >= min_confidence and entry.confidence_level <= max_confidence:
			filtered.append(entry)
	return filtered

## Gestió d'identificació d'objectes

func update_object_identification(object_id: String, new_state: String, evidence: Array[String]) -> bool:
	"""Actualitza l'estat d'identificació d'un objecte"""
	var entry = get_compendium_entry(object_id)
	if not entry:
		push_error("Intent d'actualitzar objecte no existent: %s" % object_id)
		return false
	
	var old_state = entry.current_state
	
	# Validar transició d'estat
	if not is_valid_state_transition(old_state, new_state):
		push_warning("Transició d'estat invàlida: %s -> %s" % [old_state, new_state])
		return false
	
	entry.update_identification_state(new_state, evidence)
	
	# Millorar habilitats segons el tipus de progressió
	var skill_improvement = calculate_skill_improvement(old_state, new_state)
	improve_skill("identification_skill", skill_improvement)
	
	object_identification_updated.emit(object_id, old_state, new_state)
	print("Identificació actualitzada per %s: %s -> %s (confiança: %.2f)" % [object_id, old_state, new_state, entry.confidence_level])
	
	return true

func is_valid_state_transition(from_state: String, to_state: String) -> bool:
	"""Valida si una transició d'estat és permesa"""
	var valid_transitions = {
		"unknown": ["suspected", "partial"],
		"suspected": ["unknown", "partial", "confirmed"],  # Permet retrocedir si evidència contradictòria
		"partial": ["suspected", "confirmed"],
		"confirmed": []  # No es pot retrocedir des de confirmat
	}
	
	if not valid_transitions.has(from_state):
		return false
	
	return to_state in valid_transitions[from_state]

func calculate_skill_improvement(old_state: String, new_state: String) -> int:
	"""Calcula la millora d'habilitat per una transició d'estat"""
	var improvements = {
		["unknown", "suspected"]: 2,
		["unknown", "partial"]: 4,
		["suspected", "partial"]: 3,
		["suspected", "confirmed"]: 5,
		["partial", "confirmed"]: 4
	}
	
	var key = [old_state, new_state]
	return improvements.get(key, 1)

func assign_player_name(object_id: String, name: String) -> void:
	"""Assigna un nom donat pel jugador a un objecte"""
	var entry = get_compendium_entry(object_id)
	if entry:
		entry.player_assigned_name = name
		entry.add_investigation_entry("naming", "Nom assignat pel jugador: %s" % name)

func add_suspicion(object_id: String, suspected_identity: String, reasoning: String) -> void:
	"""Afegeix una sospita sobre la identitat d'un objecte"""
	var entry = get_compendium_entry(object_id)
	if entry:
		entry.suspected_identity = suspected_identity
		entry.add_investigation_entry("hypothesis", "Sospita: %s. Raonament: %s" % [suspected_identity, reasoning])
		
		# Millorar confiança si hi ha bon raonament
		if reasoning.length() > 20:  # Raonament detallat
			entry.confidence_level = min(1.0, entry.confidence_level + 0.1)

## Gestió de propietats alquímiques

func confirm_object_property(object_id: String, property: AlchemicalPropertyResource, confirmation_method: String) -> void:
	"""Confirma una propietat alquímica d'un objecte"""
	var entry = get_compendium_entry(object_id)
	if entry:
		entry.confirm_property(property, confirmation_method)
		improve_skill("experimentation_skill", 2)
		property_confirmed.emit(object_id, property.name)

func test_property_negative(object_id: String, property_name: String, test_method: String) -> void:
	"""Registra que una propietat ha estat testejada i resultat negativa"""
	var entry = get_compendium_entry(object_id)
	if entry:
		if not entry.tested_negative_properties.has(property_name):
			entry.tested_negative_properties.append(property_name)
			entry.add_investigation_entry("negative_test", "Propietat %s testejada negativa amb mètode: %s" % [property_name, test_method])

## Gestió de relacions entre materials

func add_material_relationship(material1_id: String, material2_id: String, relationship_type: String, discovery_context: String = "") -> void:
	"""Afegeix una relació entre dos materials"""
	var entry1 = get_compendium_entry(material1_id)
	var entry2 = get_compendium_entry(material2_id)
	
	if entry1:
		entry1.add_relationship(material2_id, relationship_type, discovery_context)
	
	if entry2:
		# Afegir relació recíproca
		var reciprocal_type = get_reciprocal_relationship_type(relationship_type)
		entry2.add_relationship(material1_id, reciprocal_type, discovery_context)
	
	improve_skill("synthesis_skill", 1)

func get_reciprocal_relationship_type(relationship_type: String) -> String:
	"""Retorna el tipus de relació recíproca"""
	match relationship_type:
		"compatible":
			return "compatible"
		"incompatible":
			return "incompatible"
		"transforms_to":
			return "produced_from"
		"produced_from":
			return "transforms_to"
		_:
			return relationship_type

func get_related_materials(object_id: String, relationship_type: String = "") -> Array[String]:
	"""Retorna materials relacionats amb un objecte"""
	var entry = get_compendium_entry(object_id)
	if not entry:
		return []
	
	if relationship_type == "":
		# Retornar tots els materials relacionats
		var all_related = []
		all_related.append_array(entry.compatible_materials)
		all_related.append_array(entry.incompatible_materials)
		all_related.append_array(entry.transformation_products)
		all_related.append_array(entry.requires_for_use)
		return all_related
	
	match relationship_type:
		"compatible":
			return entry.compatible_materials
		"incompatible":
			return entry.incompatible_materials
		"transforms_to":
			return entry.transformation_products
		"requires":
			return entry.requires_for_use
		_:
			return []

## Gestió d'habilitats

func improve_skill(skill_name: String, amount: int) -> void:
	"""Millora una habilitat del jugador"""
	if not player_skills.has(skill_name):
		player_skills[skill_name] = 0
	
	var old_level = player_skills[skill_name]
	var new_level = min(100, old_level + amount)
	
	if new_level != old_level:
		player_skills[skill_name] = new_level
		skill_improved.emit(skill_name, old_level, new_level)
		
		# Comprovar si s'han desbloquejat noves capacitats
		check_skill_unlocks(skill_name, new_level)

func get_skill_level(skill_name: String) -> int:
	"""Retorna el nivell actual d'una habilitat"""
	return player_skills.get(skill_name, 0)

func get_all_skills() -> Dictionary:
	"""Retorna totes les habilitats actuals"""
	return player_skills.duplicate()

func check_skill_unlocks(skill_name: String, level: int) -> void:
	"""Comprova si s'han desbloquejat noves capacitats per nivell d'habilitat"""
	# Implementar sistema de desbloquejos per habilitats
	match skill_name:
		"identification_skill":
			if level >= 25 and not has_unlock("advanced_observation"):
				unlock_capability("advanced_observation")
			if level >= 50 and not has_unlock("microscopic_analysis"):
				unlock_capability("microscopic_analysis")
		"experimentation_skill":
			if level >= 30 and not has_unlock("complex_synthesis"):
				unlock_capability("complex_synthesis")

var unlocked_capabilities: Array[String] = []

func has_unlock(capability: String) -> bool:
	"""Comprova si una capacitat està desbloquejada"""
	return unlocked_capabilities.has(capability)

func unlock_capability(capability: String) -> void:
	"""Desbloqueja una nova capacitat"""
	if not unlocked_capabilities.has(capability):
		unlocked_capabilities.append(capability)
		print("Nova capacitat desbloquejada: %s" % capability)

## Queries i estadístiques

func get_identification_statistics() -> Dictionary:
	"""Retorna estadístiques sobre l'estat d'identificació"""
	var stats = {
		"total_objects": compendium_entries.size(),
		"unknown": 0,
		"suspected": 0,
		"partial": 0,
		"confirmed": 0
	}
	
	for entry in compendium_entries.values():
		stats[entry.current_state] += 1
	
	return stats

func get_discovery_timeline() -> Array[Dictionary]:
	"""Retorna una timeline dels descobriments"""
	var timeline = []
	for entry in compendium_entries.values():
		timeline.append({
			"date": entry.date_found,
			"object_id": entry.object_id,
			"location": entry.location_found,
			"current_state": entry.current_state
		})
	
	# Ordenar per data
	timeline.sort_custom(func(a, b): return a.date < b.date)
	return timeline

func has_unidentified_objects() -> bool:
	"""Comprova si hi ha objectes sense identificar completament"""
	for entry in compendium_entries.values():
		if entry.current_state in ["unknown", "suspected", "partial"]:
			return true
	return false

func get_objects_ready_for_experiments() -> Array[CompendiumEntryResource]:
	"""Retorna objectes que es poden utilitzar en experiments"""
	var ready = []
	for entry in compendium_entries.values():
		if entry.can_be_used_in_experiments():
			ready.append(entry)
	return ready

func search_compendium(query: String, filters: Dictionary = {}) -> Array[CompendiumEntryResource]:
	"""Cerca entrades al compendi amb query i filtres"""
	var results = []
	query = query.to_lower()
	
	for entry in compendium_entries.values():
		var matches = false
		
		# Cerca en noms i descripcions
		if entry.get_display_name().to_lower().contains(query) or \
		   entry.initial_description.to_lower().contains(query):
			matches = true
		
		# Aplicar filtres
		if matches and filters.has("state"):
			matches = entry.current_state == filters.state
		
		if matches and filters.has("min_confidence"):
			matches = entry.confidence_level >= filters.min_confidence
		
		if matches:
			results.append(entry)
	
	return results