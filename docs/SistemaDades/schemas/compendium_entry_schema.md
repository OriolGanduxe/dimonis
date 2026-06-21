# Esquema d'Entrades del Compendi

Defineix l'estructura per al [[GDD/03-sistemes#Sistema 2: El Compendi|Compendi]], el registre personal del jugador de descobriments alquímics. El compendi comença buit i es va omplint segons el jugador identifica objectes.

## Estructura de l'Entrada del Compendi

```json
{
  "entry_id": "string",
  "object_id": "string",
  "discovery_info": {
    "date_found": "datetime",
    "location_found": "string", 
    "circumstances": "string",
    "initial_description": "string"
  },
  "identification": {
    "current_state": "unknown|suspected|partial|confirmed",
    "confidence_level": "float (0.0-1.0)",
    "player_assigned_name": "string",
    "suspected_identity": "string",
    "confirmed_identity": "string"
  },
  "physical_properties": {
    "observed": {
      "color": "string",
      "texture": "string", 
      "weight": "string",
      "size": "string",
      "smell": "string",
      "other_observations": ["string"]
    },
    "measured": {
      "precise_weight": "float",
      "dimensions": "string",
      "density": "float",
      "melting_point": "float",
      "other_measurements": {"property": "value"}
    }
  },
  "investigation_history": ["InvestigationEntry"],
  "experiment_history": ["ExperimentReference"],
  "book_references": ["BookReference"], 
  "alchemical_properties": {
    "confirmed": ["Property"],
    "suspected": ["Property"],
    "tested_negative": ["Property"]
  },
  "usage_applications": {
    "confirmed_uses": ["Usage"],
    "experimental_uses": ["Usage"],
    "failed_attempts": ["Usage"]
  },
  "relationships": {
    "compatible_materials": ["string"],
    "incompatible_materials": ["string"], 
    "transformation_products": ["string"],
    "requires_for_use": ["string"]
  },
  "notes": {
    "personal_observations": ["string"],
    "theories": ["string"],
    "questions": ["string"],
    "warnings": ["string"]
  }
}
```

## Estats d'Identificació Detallats

### Unknown State
```json
{
  "state": "unknown",
  "available_info": {
    "physical_description": "Descripció visual bàsica",
    "basic_properties": ["color", "texture", "approximate_size"],
    "player_nickname": "string",
    "discovery_context": "string"
  },
  "hidden_info": "Totes les propietats alquímiques, nom real, usos",
  "actions_available": ["observe", "basic_tests", "consult_books"]
}
```

### Suspected State  
```json
{
  "state": "suspected",
  "available_info": {
    "hypothesis": "string",
    "supporting_evidence": ["string"],
    "source_of_suspicion": "book_reference|visual_similarity|test_result",
    "confidence_indicators": ["string"]
  },
  "partial_properties": ["Property"],
  "actions_available": ["verification_experiments", "detailed_research", "expert_consultation"]
}
```

### Partial State
```json
{
  "state": "partial", 
  "available_info": {
    "confirmed_identity": "string",
    "confirmed_properties": ["Property"],
    "remaining_unknowns": ["string"],
    "verification_method": "string"
  },
  "actions_available": ["complete_identification", "advanced_experiments", "practical_applications"]
}
```

### Confirmed State
```json
{
  "state": "confirmed",
  "available_info": {
    "complete_identity": "string", 
    "full_property_list": ["Property"],
    "preparation_methods": ["Method"],
    "applications": ["Usage"],
    "safety_information": ["Warning"],
    "advanced_knowledge": ["AdvancedInfo"]
  },
  "actions_available": ["all_experiments", "teaching_others", "advanced_applications"]
}
```

## Historial d'Investigació

```json
{
  "investigation_entry": {
    "entry_id": "string",
    "timestamp": "datetime",
    "type": "observation|research|experiment|consultation",
    "method": "string",
    "findings": ["string"],
    "confidence_change": "float",
    "new_leads": ["string"],
    "dead_ends": ["string"]
  }
}
```

### Tipus d'Investigacions

#### Observació Directa
```json
{
  "type": "observation",
  "tools_used": ["magnifying_glass", "scales", "flame_test"],
  "conditions": "lighting|temperature|timing",
  "observations": [
    {
      "property": "string",
      "value": "string", 
      "certainty": "certain|probable|uncertain"
    }
  ],
  "sketches": ["drawing_reference"],
  "comparisons": ["similar_object"]
}
```

#### Investigació Bibliogràfica
```json
{
  "type": "research",
  "books_consulted": ["book_id"],
  "search_terms": ["string"],
  "relevant_passages": [
    {
      "book_id": "string",
      "section": "string", 
      "quote": "string",
      "relevance": "high|medium|low",
      "reliability": "trusted|questionable|unreliable"
    }
  ],
  "cross_references": ["reference_id"],
  "contradictions_found": ["contradiction_id"]
}
```

## Propietats Alquímiques

```json
{
  "alchemical_property": {
    "property_id": "string",
    "name": "string",
    "category": "elemental|planetary|procedural|spiritual",
    "description": "string",
    "detection_method": ["string"],
    "confirmation_experiments": ["experiment_id"],
    "applications": ["usage_id"],
    "interactions": [
      {
        "with_material": "string",
        "effect": "string",
        "conditions": "string"
      }
    ],
    "safety_considerations": ["string"]
  }
}
```

### Categories de Propietats

#### Propietats Elementals
```json
{
  "elemental_properties": {
    "fire_affinity": "attracts|neutral|repels",
    "water_solubility": "soluble|insoluble|reactive", 
    "earth_stability": "stable|degrading|transforming",
    "air_volatility": "volatile|stable|fixed"
  }
}
```

#### Propietats Planetàries
```json
{
  "planetary_properties": {
    "solar_resonance": "strong|medium|weak|none",
    "lunar_sensitivity": "phases_critical|enhanced|normal|diminished",
    "mercurial_affinity": "compatible|neutral|incompatible",
    "other_planetary": {"planet": "affinity_level"}
  }
}
```

## Aplicacions i Usos

```json
{
  "usage": {
    "usage_id": "string",
    "name": "string",
    "category": "identification|synthesis|transmutation|medicinal|spiritual",
    "description": "string",
    "requirements": {
      "purity_level": "crude|refined|pure|philosophical",
      "preparation": "string",
      "additional_materials": ["string"],
      "conditions": "string",
      "equipment": ["string"]
    },
    "procedure": [
      {
        "step": "integer",
        "action": "string",
        "timing": "string",
        "critical_points": ["string"]
      }
    ],
    "success_indicators": ["string"],
    "failure_modes": [
      {
        "cause": "string",
        "symptoms": "string",
        "recovery": "string"
      }
    ],
    "results": {
      "expected": "string",
      "variations": ["string"],
      "side_effects": ["string"]
    }
  }
}
```

## Sistema de Relacions entre Materials

```json
{
  "material_relationship": {
    "relationship_id": "string",
    "primary_material": "string",
    "related_material": "string", 
    "relationship_type": "combines_with|transforms_to|catalyzes|inhibits|requires|produces",
    "conditions": "string",
    "discovery_method": "experiment|book_reference|observation",
    "reliability": "confirmed|probable|theoretical",
    "applications": ["usage_id"]
  }
}
```

## Interface d'Usuari del Compendi

### Visualització d'Entrades
```json
{
  "display_config": {
    "view_mode": "list|grid|detailed|timeline",
    "sort_by": "discovery_date|confidence|name|category",
    "filter_by": {
      "identification_state": ["unknown", "suspected", "partial", "confirmed"],
      "category": ["metals", "minerals", "herbs", "compounds"],
      "properties": ["fire_affinity", "planetary_resonance"],
      "applications": ["transmutation", "medicinal"]
    },
    "search_enabled": true,
    "cross_reference_view": "enabled|disabled"
  }
}
```

### Entrada del Jugador
```json
{
  "input_methods": {
    "note_taking": {
      "freeform_text": true,
      "structured_observations": true,
      "sketching": false,
      "voice_notes": false
    },
    "hypothesis_tracking": {
      "multiple_theories": true,
      "confidence_sliders": true,
      "evidence_linking": true
    },
    "cross_referencing": {
      "link_to_books": true,
      "link_to_experiments": true,
      "link_to_other_materials": true
    }
  }
}
```

## API per Godot

```gdscript
# CompendiumManager.gd
class_name CompendiumManager

# Gestió bàsica d'entrades
func create_entry(object_id: String, discovery_context: String) -> String
func get_entry(entry_id: String) -> CompendiumEntry
func update_identification(entry_id: String, new_state: String, evidence: Array) -> void

# Investigació
func add_investigation(entry_id: String, type: String, findings: Dictionary) -> void
func link_book_reference(entry_id: String, book_id: String, section: String) -> void
func record_experiment(entry_id: String, experiment_id: String, results: Dictionary) -> void

# Propietats i relacions
func confirm_property(entry_id: String, property_id: String, method: String) -> void
func add_relationship(entry1: String, entry2: String, type: String) -> void
func discover_application(entry_id: String, usage: Dictionary) -> void

# Consultes i cerca
func search_entries(query: String, filters: Dictionary) -> Array
func get_cross_references(entry_id: String) -> Array
func get_related_materials(entry_id: String, relationship_type: String) -> Array
```

### Senyals del Sistema
```gdscript
signal entry_created(entry_id, object_id)
signal identification_updated(entry_id, old_state, new_state)
signal property_confirmed(entry_id, property_id, confidence)
signal relationship_discovered(entry1, entry2, type)
signal application_unlocked(entry_id, usage_id)
```

## Validació i Integritat

### Regles de Consistència
- Només objectes en estat "confirmed" poden usar-se en experiments avançats
- Les propietats han de ser descobertes en ordre lògic de complexitat
- Les relacions entre materials han de ser recíproques
- L'historial d'investigació ha de ser immutable un cop registrat

### Mètriques de Progressió
```json
{
  "progression_metrics": {
    "total_entries": "integer",
    "by_state": {
      "unknown": "integer",
      "suspected": "integer", 
      "partial": "integer",
      "confirmed": "integer"
    },
    "properties_discovered": "integer",
    "applications_unlocked": "integer",
    "cross_references_found": "integer",
    "false_leads_avoided": "integer"
  }
}
```

---

Aquest esquema assegura que el Compendi funcioni com una eina d'aprenentatge genuí que reflecteix el procés real de descobriment científic.

---

Torna a [[SistemaDades/arquitectura|Arquitectura del Sistema]]