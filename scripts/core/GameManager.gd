class_name GameManager
extends Node

## Singleton que gestiona l'estat global del joc
## Implementa el layer Core de Clean Architecture

signal game_state_changed(new_state: String)
signal player_knowledge_updated
signal experiment_completed(experiment_id: String, success: bool)
signal object_identified(object_id: String, new_state: String)
signal book_accessed(book_id: String)
signal cross_reference_discovered(book1: String, book2: String)

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	LOADING,
	SAVING
}

var current_game_state: GameState = GameState.MENU
var current_save: SaveGameResource
var player_knowledge_manager: PlayerKnowledgeManager
var experiment_manager: ExperimentManager
var book_manager: BookManager

func _ready() -> void:
	"""Inicialitza el GameManager com a singleton"""
	# Configurar managers
	player_knowledge_manager = PlayerKnowledgeManager.new()
	experiment_manager = ExperimentManager.new()
	book_manager = BookManager.new()
	
	# Connectar senyals
	connect_manager_signals()
	
	print("GameManager inicialitzat correctament")

func connect_manager_signals() -> void:
	"""Connecta els senyals entre managers"""
	if player_knowledge_manager:
		player_knowledge_manager.object_identification_updated.connect(_on_object_identification_updated)
		player_knowledge_manager.skill_improved.connect(_on_skill_improved)
	
	if experiment_manager:
		experiment_manager.experiment_completed.connect(_on_experiment_completed)
		experiment_manager.discovery_made.connect(_on_discovery_made)
	
	if book_manager:
		book_manager.book_accessed.connect(_on_book_accessed)
		book_manager.cross_reference_found.connect(_on_cross_reference_found)

func start_new_game(player_name: String) -> void:
	"""Inicia una nova partida"""
	change_game_state(GameState.LOADING)
	
	current_save = SaveGameResource.new()
	current_save.initialize_new_game(player_name)
	
	# Inicialitzar managers amb el nou save
	player_knowledge_manager.initialize_from_save(current_save)
	experiment_manager.initialize_from_save(current_save)
	book_manager.initialize_from_save(current_save)
	
	change_game_state(GameState.PLAYING)
	print("Nova partida iniciada per: %s" % player_name)

func load_game(save_data: SaveGameResource) -> bool:
	"""Carrega una partida existent"""
	if not save_data or not save_data.verify_integrity():
		push_error("Save game corromput o invàlid")
		return false
	
	change_game_state(GameState.LOADING)
	
	current_save = save_data
	
	# Carregar estat als managers
	var load_success = true
	load_success = load_success and player_knowledge_manager.load_from_save(current_save)
	load_success = load_success and experiment_manager.load_from_save(current_save)
	load_success = load_success and book_manager.load_from_save(current_save)
	
	if load_success:
		change_game_state(GameState.PLAYING)
		print("Partida carregada correctament")
	else:
		change_game_state(GameState.MENU)
		push_error("Error carregant la partida")
	
	return load_success

func save_game() -> bool:
	"""Guarda la partida actual"""
	if not current_save:
		push_error("No hi ha partida activa per guardar")
		return false
	
	change_game_state(GameState.SAVING)
	
	# Actualitzar save amb estat actual dels managers
	player_knowledge_manager.update_save_data(current_save)
	experiment_manager.update_save_data(current_save)
	book_manager.update_save_data(current_save)
	
	# Actualitzar metadades
	current_save.update_last_modified()
	
	# Aquí cridaríem al SaveManager per persistir a disc
	# var save_success = SaveManager.save_to_file(current_save)
	
	change_game_state(GameState.PLAYING)
	print("Partida guardada correctament")
	return true

func change_game_state(new_state: GameState) -> void:
	"""Canvia l'estat del joc i emet el senyal corresponent"""
	if current_game_state != new_state:
		var old_state = current_game_state
		current_game_state = new_state
		game_state_changed.emit(GameState.keys()[new_state])
		print("Game state canviat de %s a %s" % [GameState.keys()[old_state], GameState.keys()[new_state]])

func pause_game() -> void:
	"""Pausa el joc"""
	if current_game_state == GameState.PLAYING:
		change_game_state(GameState.PAUSED)

func resume_game() -> void:
	"""Reprèn el joc"""
	if current_game_state == GameState.PAUSED:
		change_game_state(GameState.PLAYING)

func get_player_knowledge() -> PlayerKnowledgeManager:
	"""Retorna el gestor de coneixement del jugador"""
	return player_knowledge_manager

func get_experiment_manager() -> ExperimentManager:
	"""Retorna el gestor d'experiments"""
	return experiment_manager

func get_book_manager() -> BookManager:
	"""Retorna el gestor de llibres"""
	return book_manager

func get_current_save() -> SaveGameResource:
	"""Retorna el save actual"""
	return current_save

## Handlers per senyals dels managers

func _on_object_identification_updated(object_id: String, old_state: String, new_state: String) -> void:
	"""Gestiona actualitzacions d'identificació d'objectes"""
	print("Objecte %s: %s -> %s" % [object_id, old_state, new_state])
	object_identified.emit(object_id, new_state)
	player_knowledge_updated.emit()

func _on_skill_improved(skill_name: String, old_level: int, new_level: int) -> void:
	"""Gestiona millores d'habilitats"""
	print("Habilitat %s millorada: %d -> %d" % [skill_name, old_level, new_level])
	player_knowledge_updated.emit()

func _on_experiment_completed(experiment_id: String, success: bool, discoveries: Array) -> void:
	"""Gestiona completion d'experiments"""
	print("Experiment %s completat. Èxit: %s" % [experiment_id, success])
	experiment_completed.emit(experiment_id, success)
	
	# Processar descobriments
	for discovery in discoveries:
		process_discovery(discovery)
	
	player_knowledge_updated.emit()

func _on_discovery_made(discovery_type: String, content: String) -> void:
	"""Gestiona nous descobriments"""
	print("Nou descobriment: %s - %s" % [discovery_type, content])
	player_knowledge_updated.emit()

func _on_book_accessed(book_id: String, access_level: String) -> void:
	"""Gestiona accés a llibres"""
	print("Llibre %s accedit amb nivell: %s" % [book_id, access_level])
	book_accessed.emit(book_id)
	player_knowledge_updated.emit()

func _on_cross_reference_found(book1: String, book2: String, connection: String) -> void:
	"""Gestiona descobriment de referències creuades"""
	print("Referència creuada descoberta: %s <-> %s (%s)" % [book1, book2, connection])
	cross_reference_discovered.emit(book1, book2)
	player_knowledge_updated.emit()

func process_discovery(discovery: Dictionary) -> void:
	"""Processa un descobriment genèric"""
	match discovery.type:
		"object_identification":
			player_knowledge_manager.update_object_identification(
				discovery.object_id, 
				discovery.new_state, 
				discovery.evidence
			)
		"property_confirmation":
			player_knowledge_manager.confirm_object_property(
				discovery.object_id,
				discovery.property,
				discovery.method
			)
		"relationship_discovery":
			player_knowledge_manager.add_material_relationship(
				discovery.material1,
				discovery.material2,
				discovery.relationship_type
			)
		"experiment_unlock":
			experiment_manager.unlock_experiment(discovery.experiment_id)
		_:
			push_warning("Tipus de descobriment desconegut: %s" % discovery.type)

## Mètodes d'utilitat per la UI

func get_game_progress() -> Dictionary:
	"""Retorna informació de progrés per mostrar a la UI"""
	if not current_save:
		return {}
	
	return {
		"overall_progress": current_save.calculate_overall_progress(),
		"current_phase": current_save.current_phase,
		"objects_discovered": current_save.objects_discovered,
		"experiments_completed": current_save.experiments_succeeded,
		"books_read": current_save.books_read,
		"play_time": current_save.total_play_time
	}

func get_player_stats() -> Dictionary:
	"""Retorna estadístiques del jugador per la UI"""
	if not current_save:
		return {}
	
	return {
		"skills": current_save.get_skill_dictionary(),
		"identification_accuracy": float(current_save.correct_identifications) / max(1, current_save.correct_identifications + current_save.false_identifications),
		"experiment_success_rate": float(current_save.experiments_succeeded) / max(1, current_save.experiments_attempted),
		"false_leads_ratio": float(current_save.false_leads_followed) / max(1, current_save.false_leads_followed + current_save.false_leads_avoided)
	}

func is_game_active() -> bool:
	"""Comprova si hi ha una partida activa"""
	return current_game_state in [GameState.PLAYING, GameState.PAUSED]

func get_available_actions() -> Array[String]:
	"""Retorna les accions disponibles per al jugador en l'estat actual"""
	var actions = []
	
	if current_game_state == GameState.PLAYING:
		actions.append_array(["explore", "read_book", "experiment", "compendium", "pause"])
		
		# Accions condicionals basades en progrés
		if current_save and current_save.current_tower_level > 0:
			actions.append("access_upper_levels")
		
		if player_knowledge_manager and player_knowledge_manager.has_unidentified_objects():
			actions.append("identify_objects")
	
	return actions