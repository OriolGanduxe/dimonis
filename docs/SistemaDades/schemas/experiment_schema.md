# Esquema d'Experiments

Defineix l'estructura per als experiments del [[GDD/03-sistemes#Sistema 3: El Laboratori|Laboratori]]. Els experiments són el mètode principal per identificar materials, verificar informació i descobrir noves propietats.

## Estructura Bàsica de l'Experiment

```json
{
  "experiment_id": "string",
  "name": "string",
  "type": "identification|synthesis|transmutation|verification|exploration",
  "description": "string",
  "hypothesis": "string",
  "setup": {
    "materials": ["MaterialRequirement"],
    "equipment": ["EquipmentRequirement"], 
    "conditions": "ExperimentalConditions",
    "preparation": ["PreparationStep"]
  },
  "procedure": {
    "steps": ["ProcedureStep"],
    "timing": "TimingRequirements",
    "critical_points": ["CriticalPoint"],
    "safety_measures": ["SafetyMeasure"]
  },
  "results": {
    "possible_outcomes": ["Outcome"],
    "success_conditions": ["SuccessCondition"],
    "failure_modes": ["FailureMode"],
    "learning_outcomes": ["LearningOutcome"]
  },
  "metadata": {
    "difficulty": "basic|intermediate|advanced|master",
    "prerequisites": ["string"],
    "unlocks": ["string"],
    "estimated_duration": "string",
    "risk_level": "safe|caution|dangerous|expert_only"
  }
}
```

## Requisits de Materials

```json
{
  "material_requirement": {
    "material_id": "string",
    "identification_state_required": "unknown|suspected|partial|confirmed",
    "amount": "string",
    "purity": "crude|refined|pure|philosophical", 
    "preparation": "string",
    "substitutions": [
      {
        "substitute_id": "string",
        "conditions": "string",
        "effect_on_result": "none|minor|major|fundamental_change"
      }
    ],
    "role": "primary|secondary|catalyst|solvent|indicator"
  }
}
```

## Condicions Experimentals

```json
{
  "experimental_conditions": {
    "temperature": {
      "value": "float|string",
      "precision": "approximate|precise|critical",
      "method": "flame|athanor|solar|ambient",
      "duration": "string"
    },
    "timing": {
      "lunar_phase": "any|new|waxing|full|waning|specific",
      "time_of_day": "any|dawn|noon|sunset|midnight|specific",
      "season": "any|spring|summer|autumn|winter",
      "planetary_positions": ["string"]
    },
    "environment": {
      "lighting": "natural|candle|dark|specific",
      "humidity": "dry|normal|humid|controlled",
      "ventilation": "open|closed|controlled",
      "consecration": "none|basic|elemental|full_ritual"
    },
    "operator_state": {
      "preparation_required": "none|fasting|purification|meditation",
      "mental_state": "calm|focused|elevated|specific",
      "physical_requirements": ["string"]
    }
  }
}
```

## Pas Procedural

```json
{
  "procedure_step": {
    "step_number": "integer",
    "action": "string",
    "duration": "string",
    "method": "string",
    "visual_cues": ["string"],
    "audio_cues": ["string"],
    "temperature_changes": ["string"],
    "critical_observations": ["string"],
    "decision_points": [
      {
        "condition": "string",
        "action_if_true": "string",
        "action_if_false": "string",
        "abort_conditions": ["string"]
      }
    ],
    "safety_notes": ["string"]
  }
}
```

## Resultats i Outcomes

```json
{
  "outcome": {
    "outcome_id": "string",
    "type": "complete_success|partial_success|informative_failure|destructive_failure",
    "probability": "float (0.0-1.0)",
    "conditions_for": ["string"],
    "results": {
      "material_changes": [
        {
          "material_id": "string",
          "change_type": "transformation|purification|combination|destruction",
          "new_state": "string",
          "new_properties": ["string"]
        }
      ],
      "information_gained": [
        {
          "type": "identification|property|relationship|method",
          "content": "string",
          "confidence": "certain|probable|uncertain"
        }
      ],
      "byproducts": ["string"],
      "waste_products": ["string"]
    },
    "learning_value": {
      "identification_progress": "float (0.0-1.0)",
      "technique_mastery": "float (0.0-1.0)",
      "theoretical_understanding": "float (0.0-1.0)",
      "unlocked_experiments": ["experiment_id"]
    }
  }
}
```

## Modes de Fallada

```json
{
  "failure_mode": {
    "failure_id": "string",
    "cause": "incorrect_identification|wrong_proportions|timing_error|contamination|operator_error",
    "probability_factors": [
      {
        "factor": "string",
        "effect": "increases|decreases",
        "magnitude": "minor|moderate|major"
      }
    ],
    "symptoms": ["string"],
    "consequences": {
      "material_loss": ["string"],
      "equipment_damage": ["string"],
      "information_learned": ["string"],
      "safety_risks": ["string"]
    },
    "recovery": {
      "possible": "boolean",
      "method": "string",
      "cost": "string"
    },
    "prevention": ["string"]
  }
}
```

## Tipus d'Experiments Específics

### Experiments d'Identificació
```json
{
  "identification_experiment": {
    "target_material": "string",
    "identification_method": "flame_test|acid_test|density|magnetism|crystallization",
    "diagnostic_criteria": [
      {
        "property": "string",
        "expected_value": "string",
        "tolerance": "string",
        "significance": "diagnostic|supportive|contradictory"
      }
    ],
    "differential_diagnosis": [
      {
        "alternative_identity": "string",
        "distinguishing_test": "string"
      }
    ]
  }
}
```

### Experiments de Síntesi
```json
{
  "synthesis_experiment": {
    "target_product": "string",
    "synthesis_method": "direct_combination|indirect_preparation|catalytic|alchemical_transformation",
    "yield_expectations": {
      "theoretical_yield": "string",
      "practical_yield": "string",
      "factors_affecting_yield": ["string"]
    },
    "purity_assessment": ["string"],
    "scaling_considerations": ["string"]
  }
}
```

### Experiments de Verificació
```json
{
  "verification_experiment": {
    "claim_to_verify": "string", 
    "source_of_claim": "book_id|theory|rumor",
    "test_design": "string",
    "controls": ["string"],
    "success_criteria": "string",
    "implications": {
      "if_confirmed": ["string"],
      "if_refuted": ["string"],
      "if_inconclusive": ["string"]
    }
  }
}
```

## Historial d'Experiments del Jugador

```json
{
  "experiment_history_entry": {
    "history_id": "string",
    "experiment_id": "string",
    "timestamp": "datetime",
    "setup_used": "ExperimentSetup",
    "actual_procedure": ["ActualStep"],
    "observations": ["Observation"],
    "results_achieved": "Outcome",
    "deviations_from_plan": ["Deviation"],
    "lessons_learned": ["string"],
    "next_steps": ["string"],
    "materials_consumed": ["MaterialConsumption"],
    "equipment_status": ["EquipmentStatus"]
  }
}
```

### Observacions Detallades
```json
{
  "observation": {
    "timestamp_relative": "string",
    "observation_type": "visual|auditory|olfactory|tactile|measurement",
    "description": "string",
    "significance": "expected|unexpected|critical|concerning",
    "interpretation": "string",
    "confidence": "certain|probable|uncertain",
    "requires_followup": "boolean"
  }
}
```

## Sistema de Progressió d'Experiments

```json
{
  "experiment_progression": {
    "mastery_level": {
      "basic_techniques": "novice|apprentice|competent|proficient|expert",
      "intermediate_techniques": "locked|novice|apprentice|competent|proficient",
      "advanced_techniques": "locked|novice|apprentice|competent", 
      "master_techniques": "locked|novice"
    },
    "unlocked_experiments": ["experiment_id"],
    "technique_modifiers": [
      {
        "technique": "string",
        "modifier": "improved_precision|reduced_time|better_yield|safety_bonus"
      }
    ],
    "failure_recovery": "poor|fair|good|excellent"
  }
}
```

## Simulació d'Experiments

```json
{
  "experiment_simulation": {
    "input_validation": {
      "material_compatibility": "boolean",
      "equipment_adequacy": "boolean", 
      "condition_feasibility": "boolean",
      "operator_competence": "boolean"
    },
    "probability_calculation": {
      "base_success_rate": "float",
      "material_quality_modifier": "float",
      "equipment_quality_modifier": "float",
      "operator_skill_modifier": "float",
      "condition_precision_modifier": "float",
      "random_factors": "float"
    },
    "result_determination": {
      "outcome_selected": "string",
      "degree_of_success": "float (0.0-1.0)",
      "unexpected_discoveries": ["string"],
      "side_effects": ["string"]
    }
  }
}
```

## API per Godot

```gdscript
# ExperimentManager.gd
class_name ExperimentManager

# Gestió d'experiments
func get_available_experiments(materials: Array, equipment: Array) -> Array
func setup_experiment(experiment_id: String, materials: Dictionary) -> ExperimentSetup
func execute_experiment(setup: ExperimentSetup) -> ExperimentResult

# Simulació
func validate_experiment_setup(setup: ExperimentSetup) -> ValidationResult
func calculate_success_probability(setup: ExperimentSetup, player_skill: Dictionary) -> float
func simulate_experiment_outcome(setup: ExperimentSetup) -> SimulationResult

# Historial i progressió
func record_experiment(experiment_result: ExperimentResult) -> void
func get_experiment_history(material_id: String) -> Array
func update_technique_mastery(technique: String, success: boolean) -> void

# Descobriment
func check_for_discoveries(result: ExperimentResult) -> Array
func unlock_new_experiments(learned_info: Array) -> Array
```

### Senyals del Sistema
```gdscript
signal experiment_started(experiment_id, setup)
signal experiment_completed(experiment_id, result, success)
signal discovery_made(discovery_type, content, significance)
signal technique_improved(technique, old_level, new_level)
signal experiment_unlocked(experiment_id, unlock_reason)
```

## Experiments Predefinits del MVP

### "Prova de Flama Bàsica"
```json
{
  "experiment_id": "basic_flame_test",
  "name": "Prova de Flama Bàsica",
  "type": "identification", 
  "difficulty": "basic",
  "description": "Determinar composició mitjançant observació del color de flama",
  "materials_required": [
    {"type": "unknown_material", "amount": "small_sample"},
    {"type": "flame_source", "purity": "clean"}
  ],
  "learning_outcomes": [
    "Basic material identification",
    "Flame color interpretation", 
    "Safety with fire experiments"
  ]
}
```

---

Aquest esquema permet experiments realistes que ensenyen veritable metodologia científica mentre mantenen l'emoció del descobriment.

---

Torna a [[SistemaDades/arquitectura|Arquitectura del Sistema]]