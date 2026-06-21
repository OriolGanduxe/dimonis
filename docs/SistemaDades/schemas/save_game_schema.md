# Esquema de Partides Guardades

Defineix l'estructura completa per guardar i carregar l'estat del joc de **Dimonis**, assegurant que tot el progrés del descobriment i identificació es preservi correctament.

## Estructura Principal del Save Game

```json
{
  "save_metadata": {
    "save_id": "string (UUID)",
    "save_name": "string",
    "creation_date": "datetime",
    "last_modified": "datetime", 
    "game_version": "string",
    "play_time": "integer (seconds)",
    "character_name": "string",
    "difficulty_settings": "SaveDifficulty"
  },
  "world_state": "WorldState",
  "player_knowledge": "PlayerKnowledge", 
  "progression": "GameProgression",
  "settings": "PlayerSettings",
  "statistics": "GameStatistics"
}
```

## Estat del Món

```json
{
  "world_state": {
    "tower": {
      "current_access_level": "integer (0-3)",
      "keys_obtained": ["bronze", "silver", "gold"],
      "room_states": {
        "room_id": {
          "discovered": "boolean",
          "first_visit_date": "datetime",
          "modifications": ["Modification"],
          "available_items": ["ItemInstance"]
        }
      },
      "environmental_changes": ["EnvironmentalChange"]
    },
    "locations": {
      "location_id": {
        "discovered": "boolean",
        "accessibility": "available|locked|partially_accessible",
        "exploration_level": "float (0.0-1.0)",
        "resources_depleted": ["resource_type"],
        "events_triggered": ["event_id"]
      }
    },
    "time_state": {
      "game_day": "integer",
      "current_season": "spring|summer|autumn|winter",
      "lunar_phase": "new|waxing|full|waning", 
      "active_celestial_events": ["CelestialEvent"],
      "time_sensitive_availability": ["TimeSensitiveItem"]
    },
    "global_flags": {
      "story_flags": {"flag_name": "boolean|string|integer"},
      "quest_states": {"quest_id": "QuestState"},
      "relationship_states": {"entity_id": "RelationshipState"}
    }
  }
}
```

## Coneixement del Jugador

```json
{
  "player_knowledge": {
    "compendium": {
      "entries": {"entry_id": "CompendiumEntry"},
      "total_objects_found": "integer",
      "identification_progress": {
        "unknown": "integer",
        "suspected": "integer", 
        "partial": "integer",
        "confirmed": "integer"
      }
    },
    "library_knowledge": {
      "books_accessed": {"book_id": "BookAccessState"},
      "cross_references_discovered": ["CrossReference"],
      "contradictions_noted": ["Contradiction"],
      "hidden_information_found": ["HiddenInfo"],
      "reliability_assessments": {"book_id": "float"}
    },
    "experimental_knowledge": {
      "experiments_performed": {"experiment_id": "ExperimentHistory"},
      "techniques_mastered": {"technique": "MasteryLevel"},
      "successful_procedures": ["procedure_id"],
      "failed_attempts": ["FailedAttempt"],
      "discoveries_made": ["Discovery"]
    },
    "entity_knowledge": {
      "entities_encountered": {"entity_id": "EntityKnowledge"},
      "communication_established": ["entity_id"],
      "pacts_made": ["Pact"],
      "entity_preferences_learned": ["EntityPreference"]
    },
    "location_knowledge": {
      "maps_discovered": ["map_id"],
      "secret_passages": ["passage_id"],
      "resource_locations": ["ResourceLocation"],
      "danger_areas": ["DangerArea"]
    }
  }
}
```

### Estat d'Accés als Llibres
```json
{
  "book_access_state": {
    "access_level": "closed|browsed|studied|mastered",
    "sections_read": ["section_id"],
    "time_spent": "integer (seconds)",
    "notes_taken": ["PersonalNote"],
    "bookmarks": ["BookmarkReference"],
    "comprehension_level": "float (0.0-1.0)",
    "preferred_sections": ["section_id"]
  }
}
```

### Historial d'Experiments
```json
{
  "experiment_history": {
    "attempts": ["ExperimentAttempt"],
    "success_rate": "float (0.0-1.0)",
    "best_result": "ExperimentResult",
    "lessons_learned": ["string"],
    "technique_improvements": ["TechniqueImprovement"],
    "materials_consumed": ["MaterialConsumption"]
  }
}
```

## Progressió del Joc

```json
{
  "game_progression": {
    "current_phase": "integer (1-5)",
    "phase_progress": "float (0.0-1.0)",
    "milestones_achieved": ["milestone_id"],
    "achievements_unlocked": ["achievement_id"],
    "endings": {
      "discovered_endings": ["ending_id"],
      "completed_endings": ["ending_id"],
      "current_ending_path": "string"
    },
    "skill_development": {
      "identification_skill": "integer (0-100)",
      "experimentation_skill": "integer (0-100)", 
      "research_skill": "integer (0-100)",
      "communication_skill": "integer (0-100)",
      "synthesis_skill": "integer (0-100)"
    },
    "unlock_states": {
      "experiments_unlocked": ["experiment_id"],
      "locations_unlocked": ["location_id"],
      "books_unlocked": ["book_id"],
      "techniques_unlocked": ["technique_id"]
    }
  }
}
```

## Configuració del Jugador

```json
{
  "player_settings": {
    "gameplay": {
      "difficulty_level": "story|normal|challenging|realistic",
      "hint_system": "full|partial|minimal|disabled",
      "false_lead_frequency": "low|normal|high|maximum",
      "experimentation_realism": "arcade|realistic|simulation"
    },
    "interface": {
      "compendium_view": "simple|detailed|academic",
      "note_taking_style": "guided|freeform|hybrid",
      "cross_reference_highlights": "enabled|disabled",
      "measurement_units": "metric|imperial|alchemical"
    },
    "accessibility": {
      "text_size": "small|normal|large|extra_large",
      "color_blind_support": "enabled|disabled",
      "motion_reduction": "enabled|disabled",
      "audio_descriptions": "enabled|disabled"
    },
    "external_tools": {
      "notebook_integration": "physical|digital|hybrid|none",
      "screenshot_organization": "enabled|disabled",
      "external_note_sync": "enabled|disabled"
    }
  }
}
```

## Estadístiques del Joc

```json
{
  "game_statistics": {
    "time_tracking": {
      "total_play_time": "integer (seconds)",
      "time_in_library": "integer (seconds)",
      "time_in_laboratory": "integer (seconds)",
      "time_exploring": "integer (seconds)",
      "time_taking_notes": "integer (seconds)"
    },
    "discovery_stats": {
      "objects_discovered": "integer",
      "correct_identifications": "integer", 
      "false_identifications": "integer",
      "experiments_attempted": "integer",
      "experiments_succeeded": "integer",
      "books_read": "integer",
      "cross_references_found": "integer"
    },
    "efficiency_metrics": {
      "average_identification_time": "float (seconds)",
      "identification_accuracy": "float (0.0-1.0)",
      "research_efficiency": "float",
      "experimentation_success_rate": "float (0.0-1.0)"
    },
    "progression_tracking": {
      "false_leads_followed": "integer",
      "false_leads_avoided": "integer",
      "hidden_information_discovered": "integer",
      "advanced_techniques_mastered": "integer"
    }
  }
}
```

## Instàncies d'Objectes

```json
{
  "item_instance": {
    "instance_id": "string (UUID)",
    "base_object_id": "string",
    "location": "string",
    "stack_size": "integer",
    "quality": "poor|average|good|excellent|perfect",
    "purity": "crude|refined|pure|philosophical",
    "modifications": ["Modification"],
    "history": {
      "origin": "string",
      "previous_owners": ["string"],
      "transformations": ["Transformation"],
      "experiments_used_in": ["experiment_id"]
    },
    "condition": {
      "physical_state": "solid|liquid|gas|plasma|ethereal",
      "degradation_level": "float (0.0-1.0)",
      "contamination": ["contaminant_id"],
      "special_properties": ["property_id"]
    }
  }
}
```

## Sistema de Versionat i Migrations

```json
{
  "versioning": {
    "save_format_version": "string (semantic versioning)",
    "game_content_version": "string",
    "compatibility_level": "full|partial|migration_required|incompatible",
    "migration_log": [
      {
        "from_version": "string",
        "to_version": "string", 
        "changes_applied": ["string"],
        "data_lost": ["string"]
      }
    ]
  }
}
```

## Compressió i Optimització

```json
{
  "compression_settings": {
    "use_compression": "boolean",
    "compression_algorithm": "gzip|lz4|custom",
    "exclude_from_compression": ["large_texts", "player_notes"],
    "delta_compression": "enabled|disabled"
  },
  "optimization": {
    "remove_redundant_data": "boolean",
    "consolidate_histories": "boolean", 
    "archive_old_experiments": "boolean",
    "cleanup_temporary_flags": "boolean"
  }
}
```

## API de Save/Load per Godot

```gdscript
# SaveGameManager.gd
class_name SaveGameManager

# Operacions bàsiques
func save_game(slot: int, save_name: String) -> bool
func load_game(slot: int) -> bool
func delete_save(slot: int) -> bool
func get_save_list() -> Array

# Gestió d'estat
func capture_world_state() -> Dictionary
func capture_player_knowledge() -> Dictionary
func capture_progression() -> Dictionary
func restore_game_state(save_data: Dictionary) -> bool

# Migrations
func check_save_compatibility(save_data: Dictionary) -> String
func migrate_save_data(save_data: Dictionary, target_version: String) -> Dictionary
func backup_save_before_migration(slot: int) -> bool

# Utilitats
func export_save_for_sharing(slot: int, include_spoilers: bool) -> String
func import_shared_save(data: String) -> int
func get_save_statistics(slot: int) -> Dictionary
func validate_save_integrity(slot: int) -> bool
```

### Senyals del Sistema
```gdscript
signal save_started(slot, save_name)
signal save_completed(slot, success, error_message)
signal load_started(slot)
signal load_completed(slot, success, error_message)
signal migration_required(old_version, new_version)
signal migration_completed(success, changes_applied)
```

## Seguretat i Integritat

### Checksums i Validació
```json
{
  "integrity": {
    "checksum_algorithm": "SHA256",
    "save_checksum": "string",
    "critical_data_checksums": {"section": "checksum"},
    "tamper_detection": "enabled|disabled",
    "auto_repair": "enabled|disabled"
  }
}
```

### Backups Automàtics
```json
{
  "backup_system": {
    "auto_backup_enabled": "boolean",
    "backup_frequency": "every_save|hourly|daily",
    "max_backups": "integer",
    "backup_compression": "enabled|disabled",
    "backup_validation": "enabled|disabled"
  }
}
```

## Configuració de Debug

```json
{
  "debug_info": {
    "include_debug_data": "boolean",
    "save_performance_metrics": "boolean", 
    "include_system_info": "boolean",
    "development_flags": ["flag_name"],
    "testing_overrides": {"setting": "value"}
  }
}
```

---

Aquest esquema assegura que tot el progrés del jugador es preservi correctament, incloent el coneixement descobert gradualment que és central a l'experiència de **Dimonis**.

---

Torna a [[SistemaDades/arquitectura|Arquitectura del Sistema]]