class_name ExperimentResource
extends Resource

## Defineix un experiment alquímic seguint l'esquema del GDD
## Implementa el sistema de experimentació amb validació d'identificació de materials

@export var experiment_id: String = ""
@export var name: String = ""
@export var experiment_type: String = "identification"  # identification|synthesis|transmutation|verification|exploration
@export var description: String = ""
@export var hypothesis: String = ""

@export_group("Requirements")
@export var required_materials: Array[MaterialRequirementResource] = []
@export var required_equipment: Array[String] = []
@export var required_conditions: ExperimentalConditionsResource
@export var preparation_steps: Array[String] = []

@export_group("Procedure")
@export var procedure_steps: Array[ProcedureStepResource] = []
@export var timing_requirements: String = ""
@export var critical_points: Array[String] = []
@export var safety_measures: Array[String] = []

@export_group("Results")
@export var possible_outcomes: Array[ExperimentOutcomeResource] = []
@export var success_conditions: Array[String] = []
@export var failure_modes: Array[ExperimentFailureResource] = []
@export var learning_outcomes: Array[String] = []

@export_group("Metadata")
@export var difficulty: String = "basic"  # basic|intermediate|advanced|master
@export var prerequisites: Array[String] = []
@export var unlocks: Array[String] = []  # Què desbloqueja aquest experiment
@export var estimated_duration: String = ""
@export var risk_level: String = "safe"  # safe|caution|dangerous|expert_only

## Mètodes de validació i simulació

func validate_setup(available_materials: Array[CompendiumEntryResource], available_equipment: Array[String], player_skills: Dictionary) -> Dictionary:
	"""Valida si l'experiment es pot realitzar amb els recursos disponibles"""
	var validation_result = {
		"valid": true,
		"errors": [],
		"warnings": [],
		"success_probability": 0.0
	}
	
	# Validar materials
	var material_validation = validate_materials(available_materials)
	if not material_validation.valid:
		validation_result.valid = false
		validation_result.errors.append_array(material_validation.errors)
	
	# Validar equipament
	if not validate_equipment(available_equipment):
		validation_result.valid = false
		validation_result.errors.append("Equipament insuficient o inadequat")
	
	# Validar habilitats del jugador
	var skill_validation = validate_player_skills(player_skills)
	validation_result.warnings.append_array(skill_validation.warnings)
	
	# Calcular probabilitat d'èxit
	if validation_result.valid:
		validation_result.success_probability = calculate_success_probability(available_materials, player_skills)
	
	return validation_result

func validate_materials(available_materials: Array[CompendiumEntryResource]) -> Dictionary:
	"""Valida que els materials requerits estiguin disponibles i correctament identificats"""
	var result = {"valid": true, "errors": []}
	
	for material_req in required_materials:
		var material_found = false
		var correct_identification = false
		
		for available_material in available_materials:
			if available_material.object_id == material_req.material_id:
				material_found = true
				
				# Verificar estat d'identificació
				match material_req.identification_state_required:
					"unknown":
						correct_identification = true  # Qualsevol estat serveix
					"suspected":
						correct_identification = available_material.current_state in ["suspected", "partial", "confirmed"]
					"partial":
						correct_identification = available_material.current_state in ["partial", "confirmed"]  
					"confirmed":
						correct_identification = available_material.current_state == "confirmed"
				
				if not correct_identification:
					result.valid = false
					result.errors.append("Material %s requereix identificació %s, però està en estat %s" % [
						material_req.material_id, 
						material_req.identification_state_required,
						available_material.current_state
					])
				break
		
		if not material_found:
			result.valid = false
			result.errors.append("Material requerit no trobat: %s" % material_req.material_id)
	
	return result

func validate_equipment(available_equipment: Array[String]) -> bool:
	"""Valida que l'equipament requerit estigui disponible"""
	for required_item in required_equipment:
		if not available_equipment.has(required_item):
			return false
	return true

func validate_player_skills(player_skills: Dictionary) -> Dictionary:
	"""Valida les habilitats del jugador i genera advertències si són inadequades"""
	var result = {"warnings": []}
	
	var required_skill_level = get_required_skill_level_for_difficulty()
	
	for skill_name in ["identification_skill", "experimentation_skill", "safety_knowledge"]:
		var player_level = player_skills.get(skill_name, 0)
		if player_level < required_skill_level:
			result.warnings.append("Habilitat %s baixa (nivell %d, recomanat %d)" % [skill_name, player_level, required_skill_level])
	
	return result

func calculate_success_probability(materials: Array[CompendiumEntryResource], player_skills: Dictionary) -> float:
	"""Calcula la probabilitat d'èxit basada en la qualitat dels materials i habilitats del jugador"""
	var base_probability = 0.5  # Probabilitat base del 50%
	
	# Modificador per qualitat d'identificació dels materials
	var identification_bonus = 0.0
	for material in materials:
		match material.current_state:
			"unknown":
				identification_bonus -= 0.3  # Penalització forta per materials no identificats
			"suspected":
				identification_bonus -= 0.1  # Penalització lleu
			"partial":
				identification_bonus += 0.05  # Bonus petit
			"confirmed":
				identification_bonus += 0.1   # Bonus complet
	
	# Modificador per habilitats del jugador
	var skill_bonus = 0.0
	var avg_skill = (
		player_skills.get("identification_skill", 0) +
		player_skills.get("experimentation_skill", 0) +
		player_skills.get("safety_knowledge", 0)
	) / 3.0 / 100.0  # Normalitzar a 0-1
	
	skill_bonus = (avg_skill - 0.5) * 0.2  # ±20% basat en habilitats
	
	# Modificador per dificultat
	var difficulty_modifier = get_difficulty_modifier()
	
	return clamp(base_probability + identification_bonus + skill_bonus + difficulty_modifier, 0.1, 0.95)

func get_required_skill_level_for_difficulty() -> int:
	"""Retorna el nivell d'habilitat recomanat per aquesta dificultat"""
	match difficulty:
		"basic":
			return 10
		"intermediate":
			return 30
		"advanced":
			return 60
		"master":
			return 80
		_:
			return 0

func get_difficulty_modifier() -> float:
	"""Retorna el modificador de probabilitat basat en la dificultat"""
	match difficulty:
		"basic":
			return 0.2   # +20% per experiments bàsics
		"intermediate":
			return 0.0   # Neutral
		"advanced":
			return -0.15  # -15% per experiments avançats
		"master":
			return -0.3   # -30% per experiments de mestre
		_:
			return 0.0

func simulate_execution(setup_materials: Array[CompendiumEntryResource], player_skills: Dictionary, random_seed: int = -1) -> ExperimentResultResource:
	"""Simula l'execució de l'experiment i retorna el resultat"""
	if random_seed != -1:
		seed(random_seed)
	
	var result = ExperimentResultResource.new()
	result.experiment_id = experiment_id
	result.timestamp = Time.get_datetime_string_from_system()
	result.materials_used = setup_materials
	
	var success_probability = calculate_success_probability(setup_materials, player_skills)
	var random_roll = randf()
	
	if random_roll <= success_probability:
		# Èxit - seleccionar outcome de èxit
		result.outcome = select_success_outcome(setup_materials, player_skills)
		result.success = true
	else:
		# Fallada - seleccionar mode de fallada apropiat
		result.outcome = select_failure_outcome(setup_materials, player_skills, random_roll)
		result.success = false
	
	# Calcular aprenentatges i descobriments
	result.knowledge_gained = calculate_knowledge_gained(result.success, setup_materials)
	result.new_experiments_unlocked = check_for_unlocked_experiments(result.knowledge_gained)
	
	return result

func select_success_outcome(materials: Array[CompendiumEntryResource], skills: Dictionary) -> ExperimentOutcomeResource:
	"""Selecciona l'outcome apropiat per a un experiment exitós"""
	# Implementar lògica de selecció d'outcomes
	if possible_outcomes.size() > 0:
		return possible_outcomes[0]  # Simplificat per ara
	return null

func select_failure_outcome(materials: Array[CompendiumEntryResource], skills: Dictionary, roll: float) -> ExperimentFailureResource:
	"""Selecciona el mode de fallada apropiat"""
	# Implementar lògica de selecció de fallades
	if failure_modes.size() > 0:
		return failure_modes[0]  # Simplificat per ara
	return null

func calculate_knowledge_gained(success: bool, materials: Array[CompendiumEntryResource]) -> Dictionary:
	"""Calcula el coneixement guanyat de l'experiment"""
	var knowledge = {
		"identification_progress": {},
		"property_discoveries": [],
		"relationship_discoveries": [],
		"technique_mastery": 0.1
	}
	
	# Més coneixement per experiments exitosos
	if success:
		knowledge.technique_mastery = 0.2
		# Afegir lògica específica d'aprenentatge
	else:
		# Fins i tot els experiments fallits ensenyen alguna cosa
		knowledge.technique_mastery = 0.05
	
	return knowledge

func check_for_unlocked_experiments(knowledge_gained: Dictionary) -> Array[String]:
	"""Comprova si aquest experiment desbloqueja nous experiments"""
	# Implementar lògica de desbloqueig
	return unlocks

func meets_prerequisites(player_knowledge: Dictionary) -> bool:
	"""Comprova si el jugador compleix els prerequisits per aquest experiment"""
	for prerequisite in prerequisites:
		if not player_knowledge.has(prerequisite):
			return false
	return true

func get_safety_warnings_for_setup(materials: Array[CompendiumEntryResource]) -> Array[String]:
	"""Genera advertències de seguretat específiques per als materials utilitzats"""
	var warnings = safety_measures.duplicate()
	
	# Afegir advertències específiques dels materials
	for material in materials:
		if material.confirmed_properties:
			for property in material.confirmed_properties:
				if property.has_safety_concerns():
					warnings.append("ATENCIÓ: %s pot ser perillós - %s" % [material.get_display_name(), property.safety_warning])
	
	return warnings