class_name SaveGameResource
extends Resource

## Resource per gestionar l'estat complet d'una partida guardada
## Implementa l'esquema definit al GDD per save games

@export_group("Save Metadata")
@export var save_id: String = ""
@export var save_name: String = ""
@export var creation_date: String = ""
@export var last_modified: String = ""
@export var game_version: String = "0.1.0"
@export var play_time_seconds: int = 0
@export var character_name: String = ""

@export_group("World State")
@export var current_tower_level: int = 0  # 0-3
@export var keys_obtained: Array[String] = []  # bronze, silver, gold
@export var room_states: Dictionary = {}  # room_id -> RoomStateResource
@export var environmental_changes: Array[String] = []
@export var global_story_flags: Dictionary = {}
@export var active_quests: Array[String] = []

@export_group("Time State")  
@export var game_day: int = 1
@export var current_season: String = "spring"
@export var lunar_phase: String = "new"
@export var time_sensitive_events: Array[String] = []

@export_group("Player Knowledge")
@export var compendium_entries: Array[CompendiumEntryResource] = []
@export var books_accessed: Dictionary = {}  # book_id -> BookAccessStateResource
@export var cross_references_discovered: Array[String] = []
@export var contradictions_noted: Array[String] = []
@export var hidden_information_found: Array[String] = []
@export var book_reliability_assessments: Dictionary = {}  # book_id -> float

@export_group("Experimental Knowledge")
@export var experiments_performed: Dictionary = {}  # experiment_id -> ExperimentHistoryResource
@export var techniques_mastered: Dictionary = {}  # technique -> mastery_level
@export var successful_procedures: Array[String] = []
@export var failed_attempts: Array[String] = []
@export var experimental_discoveries: Array[String] = []

@export_group("Entity Knowledge")
@export var entities_encountered: Dictionary = {}
@export var communication_established: Array[String] = []
@export var entity_relationships: Dictionary = {}

@export_group("Game Progression")
@export var current_phase: int = 1  # 1-5
@export var phase_progress: float = 0.0  # 0.0-1.0
@export var milestones_achieved: Array[String] = []
@export var achievements_unlocked: Array[String] = []
@export var discovered_endings: Array[String] = []
@export var completed_endings: Array[String] = []
@export var current_ending_path: String = ""

@export_group("Skills")
@export var identification_skill: int = 0  # 0-100
@export var experimentation_skill: int = 0  # 0-100
@export var research_skill: int = 0  # 0-100
@export var communication_skill: int = 0  # 0-100
@export var synthesis_skill: int = 0  # 0-100

@export_group("Unlocked Content")
@export var experiments_unlocked: Array[String] = []
@export var locations_unlocked: Array[String] = []
@export var books_unlocked: Array[String] = []
@export var techniques_unlocked: Array[String] = []

@export_group("Player Settings")
@export var difficulty_level: String = "normal"  # story|normal|challenging|realistic
@export var hint_system: String = "partial"  # full|partial|minimal|disabled
@export var false_lead_frequency: String = "normal"  # low|normal|high|maximum
@export var experimentation_realism: String = "realistic"  # arcade|realistic|simulation

@export_group("Statistics")
@export var total_play_time: int = 0
@export var time_in_library: int = 0
@export var time_in_laboratory: int = 0
@export var time_exploring: int = 0
@export var objects_discovered: int = 0
@export var correct_identifications: int = 0
@export var false_identifications: int = 0
@export var experiments_attempted: int = 0
@export var experiments_succeeded: int = 0
@export var books_read: int = 0
@export var false_leads_followed: int = 0
@export var false_leads_avoided: int = 0

@export_group("Integrity")
@export var save_checksum: String = ""
@export var format_version: String = "1.0"

## Mètodes de gestió d'estat

func initialize_new_game(player_name: String) -> void:
	"""Inicialitza una nova partida amb valors per defecte"""
	save_id = generate_save_id()
	save_name = "Nova Partida"
	character_name = player_name
	creation_date = Time.get_datetime_string_from_system()
	last_modified = creation_date
	
	# Configuració inicial del món
	current_tower_level = 0
	keys_obtained = []
	game_day = 1
	current_season = "spring"
	lunar_phase = "new"
	
	# Habilitats inicials
	identification_skill = 5
	experimentation_skill = 5  
	research_skill = 5
	communication_skill = 0
	synthesis_skill = 0
	
	# Experiments inicials desblocats
	experiments_unlocked = ["basic_observation", "basic_flame_test"]
	
	# Primer llibre disponible
	books_unlocked = ["basic_manual"]
	
	update_checksum()

func update_last_modified() -> void:
	"""Actualitza el timestamp de darrera modificació"""
	last_modified = Time.get_datetime_string_from_system()
	update_checksum()

func add_compendium_entry(entry: CompendiumEntryResource) -> void:
	"""Afegeix una nova entrada al compendi"""
	if not has_compendium_entry(entry.object_id):
		compendium_entries.append(entry)
		objects_discovered += 1
		update_last_modified()

func get_compendium_entry(object_id: String) -> CompendiumEntryResource:
	"""Recupera una entrada del compendi per ID d'objecte"""
	for entry in compendium_entries:
		if entry.object_id == object_id:
			return entry
	return null

func has_compendium_entry(object_id: String) -> bool:
	"""Comprova si existeix una entrada per a l'objecte especificat"""
	return get_compendium_entry(object_id) != null

func update_compendium_entry_state(object_id: String, new_state: String, evidence: Array[String]) -> void:
	"""Actualitza l'estat d'identificació d'una entrada del compendi"""
	var entry = get_compendium_entry(object_id)
	if entry:
		entry.update_identification_state(new_state, evidence)
		
		# Actualitzar estadístiques
		match new_state:
			"confirmed":
				correct_identifications += 1
		
		update_last_modified()

func record_experiment(experiment_id: String, result: ExperimentResultResource) -> void:
	"""Registra el resultat d'un experiment realitzat"""
	if not experiments_performed.has(experiment_id):
		experiments_performed[experiment_id] = []
	
	experiments_performed[experiment_id].append(result)
	experiments_attempted += 1
	
	if result.success:
		experiments_succeeded += 1
		if not successful_procedures.has(experiment_id):
			successful_procedures.append(experiment_id)
	else:
		if not failed_attempts.has(experiment_id):
			failed_attempts.append(experiment_id)
	
	# Actualitzar habilitats basades en l'experiment
	improve_skill_from_experiment(experiment_id, result.success)
	update_last_modified()

func improve_skill_from_experiment(experiment_id: String, success: bool) -> void:
	"""Millora les habilitats del jugador basant-se en l'experiment realitzat"""
	var base_improvement = 1 if success else 0.5
	
	experimentation_skill = min(100, experimentation_skill + base_improvement)
	
	# Millorar habilitats específiques segons el tipus d'experiment
	# (això requerirà accedir a ExperimentResource per obtenir el tipus)

func access_book(book_id: String, access_level: String) -> void:
	"""Registra l'accés a un llibre"""
	if not books_accessed.has(book_id):
		books_accessed[book_id] = create_book_access_state()
		books_read += 1
	
	var access_state = books_accessed[book_id]
	if access_state.access_level != access_level:
		access_state.access_level = access_level
		access_state.time_spent += 1  # Simplificat
	
	update_last_modified()

func create_book_access_state() -> Dictionary:
	"""Crea un nou estat d'accés per a un llibre"""
	return {
		"access_level": "closed",
		"sections_read": [],
		"time_spent": 0,
		"notes_taken": [],
		"bookmarks": [],
		"comprehension_level": 0.0
	}

func discover_cross_reference(book1_id: String, book2_id: String, connection_type: String) -> void:
	"""Registra el descobriment d'una referència creuada entre llibres"""
	var reference_id = "%s_%s_%s" % [book1_id, book2_id, connection_type]
	if not cross_references_discovered.has(reference_id):
		cross_references_discovered.append(reference_id)
		research_skill = min(100, research_skill + 2)
		update_last_modified()

func unlock_experiment(experiment_id: String) -> void:
	"""Desbloqueja un nou experiment"""
	if not experiments_unlocked.has(experiment_id):
		experiments_unlocked.append(experiment_id)
		update_last_modified()

func unlock_location(location_id: String) -> void:
	"""Desbloqueja una nova localització"""
	if not locations_unlocked.has(location_id):
		locations_unlocked.append(location_id)
		update_last_modified()

func advance_phase(new_phase: int) -> void:
	"""Avança a la següent fase del joc"""
	if new_phase > current_phase:
		current_phase = new_phase
		phase_progress = 0.0
		milestones_achieved.append("phase_%d_reached" % new_phase)
		update_last_modified()

func calculate_overall_progress() -> float:
	"""Calcula el progrés general de la partida (0.0-1.0)"""
	var progress_factors = [
		float(objects_discovered) / 50.0,  # Assumim 50 objectes totals
		float(correct_identifications) / 30.0,  # 30 identificacions correctes
		float(experiments_succeeded) / 20.0,  # 20 experiments exitosos
		float(books_read) / 10.0,  # 10 llibres totals
		float(current_phase - 1) / 4.0  # 5 fases (0-4 normalitzat)
	]
	
	var total_progress = 0.0
	for factor in progress_factors:
		total_progress += min(1.0, factor)
	
	return total_progress / float(progress_factors.size())

func get_skill_dictionary() -> Dictionary:
	"""Retorna les habilitats com a diccionari per facilitar els càlculs"""
	return {
		"identification_skill": identification_skill,
		"experimentation_skill": experimentation_skill,
		"research_skill": research_skill,
		"communication_skill": communication_skill,
		"synthesis_skill": synthesis_skill
	}

func is_compatible_with_version(target_version: String) -> bool:
	"""Comprova si aquest save és compatible amb la versió del joc especificada"""
	# Implementar lògica de compatibilitat de versions
	return format_version == "1.0"  # Simplificat per ara

func generate_save_id() -> String:
	"""Genera un ID únic per a aquest save"""
	return "save_%d_%s" % [Time.get_ticks_msec(), character_name.to_lower().replace(" ", "_")]

func update_checksum() -> void:
	"""Actualitza el checksum per verificar la integritat del save"""
	# Implementació simplificada - en producció utilitzar hash real
	var data_string = "%s_%s_%d_%d" % [save_id, character_name, play_time_seconds, objects_discovered]
	save_checksum = str(data_string.hash())

func verify_integrity() -> bool:
	"""Verifica la integritat d'aquest save"""
	var current_checksum = save_checksum
	update_checksum()
	var calculated_checksum = save_checksum
	save_checksum = current_checksum
	
	return current_checksum == calculated_checksum