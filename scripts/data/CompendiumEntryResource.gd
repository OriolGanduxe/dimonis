class_name CompendiumEntryResource
extends Resource

## Entrada del compendi del jugador - implementa el sistema de descobriment gradual
## Segueix el schema definit al GDD per entrades del compendi

@export var entry_id: String = ""
@export var object_id: String = ""  # ID de l'objecte real al món

@export_group("Discovery Info")
@export var date_found: String = ""
@export var location_found: String = ""
@export var circumstances: String = ""
@export var initial_description: String = ""

@export_group("Identification State")
@export var current_state: String = "unknown"  # unknown|suspected|partial|confirmed
@export var confidence_level: float = 0.0  # 0.0-1.0
@export var player_assigned_name: String = ""
@export var suspected_identity: String = ""
@export var confirmed_identity: String = ""

@export_group("Physical Properties")
@export var observed_color: String = ""
@export var observed_texture: String = ""
@export var observed_weight: String = ""
@export var observed_size: String = ""
@export var observed_smell: String = ""
@export var other_observations: Array[String] = []

@export_group("Measured Properties")
@export var precise_weight: float = 0.0
@export var dimensions: String = ""
@export var density: float = 0.0
@export var melting_point: float = 0.0
@export var measured_properties: Dictionary = {}

@export_group("Investigation History")
@export var investigation_entries: Array[InvestigationEntryResource] = []
@export var experiment_references: Array[String] = []  # IDs d'experiments
@export var book_references: Array[String] = []  # IDs de llibres consultats

@export_group("Alchemical Properties")
@export var confirmed_properties: Array[AlchemicalPropertyResource] = []
@export var suspected_properties: Array[AlchemicalPropertyResource] = []
@export var tested_negative_properties: Array[String] = []

@export_group("Usage Applications")
@export var confirmed_uses: Array[MaterialUsageResource] = []
@export var experimental_uses: Array[MaterialUsageResource] = []
@export var failed_attempts: Array[MaterialUsageResource] = []

@export_group("Relationships")
@export var compatible_materials: Array[String] = []
@export var incompatible_materials: Array[String] = []
@export var transformation_products: Array[String] = []
@export var requires_for_use: Array[String] = []

@export_group("Personal Notes")
@export var personal_observations: Array[String] = []
@export var theories: Array[String] = []
@export var questions: Array[String] = []
@export var warnings: Array[String] = []

## Mètodes per gestionar l'estat d'identificació

func update_identification_state(new_state: String, evidence: Array[String]) -> void:
	"""Actualitza l'estat d'identificació amb nova evidència"""
	var old_state = current_state
	current_state = new_state
	
	# Actualitza confiança basada en evidència
	confidence_level = calculate_confidence_from_evidence(evidence)
	
	# Afegeix entrada d'investigació
	add_investigation_entry("state_change", "Estat canviat de %s a %s" % [old_state, new_state])

func add_investigation_entry(type: String, description: String) -> void:
	"""Afegeix una nova entrada al historial d'investigació"""
	var entry = InvestigationEntryResource.new()
	entry.entry_id = generate_unique_id()
	entry.timestamp = Time.get_datetime_string_from_system()
	entry.investigation_type = type
	entry.description = description
	investigation_entries.append(entry)

func calculate_confidence_from_evidence(evidence: Array[String]) -> float:
	"""Calcula el nivell de confiança basant-se en l'evidència disponible"""
	# Implementar lògica de càlcul de confiança
	var base_confidence = 0.1
	var evidence_bonus = evidence.size() * 0.15
	return min(1.0, base_confidence + evidence_bonus)

func can_be_used_in_experiments() -> bool:
	"""Determina si aquest material pot ser utilitzat en experiments segons el seu estat d'identificació"""
	match current_state:
		"unknown":
			return false  # No es pot usar si no sabem què és
		"suspected":
			return confidence_level > 0.3  # Només amb confiança mínima
		"partial":
			return true  # Es pot usar amb precaució
		"confirmed":
			return true  # Ús complet disponible
		_:
			return false

func get_display_name() -> String:
	"""Retorna el nom que s'ha de mostrar al jugador segons l'estat d'identificació"""
	match current_state:
		"unknown":
			return player_assigned_name if player_assigned_name != "" else "Objecte desconegut"
		"suspected":
			return "%s (?)" % suspected_identity if suspected_identity != "" else player_assigned_name
		"partial":
			return "%s (parcial)" % suspected_identity if suspected_identity != "" else player_assigned_name
		"confirmed":
			return confirmed_identity
		_:
			return "ERROR: Estat desconegut"

func get_available_information_for_state() -> Dictionary:
	"""Retorna la informació disponible per al jugador segons l'estat actual"""
	var info = {
		"basic_observations": [observed_color, observed_texture, observed_weight, observed_size],
		"personal_notes": personal_observations,
		"investigation_history": investigation_entries
	}
	
	match current_state:
		"suspected", "partial", "confirmed":
			info["suspected_properties"] = suspected_properties
		"partial", "confirmed":
			info["confirmed_properties"] = confirmed_properties
			info["measured_properties"] = measured_properties
		"confirmed":
			info["all_properties"] = confirmed_properties
			info["usage_applications"] = confirmed_uses
			info["relationships"] = {
				"compatible": compatible_materials,
				"incompatible": incompatible_materials
			}
	
	return info

func add_book_reference(book_id: String, section_id: String, relevance: String) -> void:
	"""Afegeix una referència a un llibre consultat durant la investigació"""
	if not book_references.has(book_id):
		book_references.append(book_id)
		add_investigation_entry("research", "Consultat llibre: %s (secció: %s, rellevància: %s)" % [book_id, section_id, relevance])

func link_to_experiment(experiment_id: String, result_summary: String) -> void:
	"""Enllaça aquesta entrada amb un experiment realitzat"""
	if not experiment_references.has(experiment_id):
		experiment_references.append(experiment_id)
		add_investigation_entry("experiment", "Experiment realitzat: %s. Resultat: %s" % [experiment_id, result_summary])

func confirm_property(property: AlchemicalPropertyResource, confirmation_method: String) -> void:
	"""Confirma una propietat alquímica d'aquest material"""
	# Mou de suspected a confirmed
	if suspected_properties.has(property):
		suspected_properties.erase(property)
	
	if not confirmed_properties.has(property):
		confirmed_properties.append(property)
		add_investigation_entry("property_confirmed", "Propietat confirmada: %s (mètode: %s)" % [property.name, confirmation_method])

func add_relationship(other_material_id: String, relationship_type: String, discovery_context: String) -> void:
	"""Afegeix una relació amb un altre material"""
	match relationship_type:
		"compatible":
			if not compatible_materials.has(other_material_id):
				compatible_materials.append(other_material_id)
		"incompatible":
			if not incompatible_materials.has(other_material_id):
				incompatible_materials.append(other_material_id)
		"transforms_to":
			if not transformation_products.has(other_material_id):
				transformation_products.append(other_material_id)
	
	add_investigation_entry("relationship", "Relació descoberta amb %s: %s (%s)" % [other_material_id, relationship_type, discovery_context])

func generate_unique_id() -> String:
	"""Genera un ID únic per a les entrades d'investigació"""
	return "%s_%d" % [entry_id, Time.get_ticks_msec()]