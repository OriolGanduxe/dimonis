# Esquema de Llibres

Defineix l'estructura de dades per als llibres i texts de la [[GDD/03-sistemes#Sistema 1: La Biblioteca|Biblioteca]]. Els llibres són la font principal d'informació però contenen deliberadament contradiccions i falses pistes.

## Estructura Bàsica del Llibre

```json
{
  "book_id": "string",
  "title": "string", 
  "author": "string",
  "year_written": "integer",
  "reliability_level": "float (0.0-1.0)",
  "category": "string",
  "physical_properties": {
    "condition": "excellent|good|damaged|fragmentary",
    "material": "parchment|paper|vellum",
    "binding": "leather|wooden|damaged",
    "illustrations": "boolean",
    "pages": "integer"
  },
  "access_requirements": {
    "tower_level": "integer (0-3)",
    "prerequisite_knowledge": ["string"],
    "special_conditions": "string"
  },
  "content": {
    "chapters": ["Chapter"],
    "cross_references": ["CrossReference"],
    "contradictions": ["Contradiction"],
    "hidden_information": ["HiddenInfo"]
  },
  "metadata": {
    "discovery_state": "closed|browsed|studied|mastered",
    "player_notes": ["string"],
    "marked_passages": ["PassageReference"],
    "times_consulted": "integer"
  }
}
```

## Estructura de Capítols

```json
{
  "chapter_id": "string",
  "title": "string",
  "content_type": "theoretical|practical|reference|narrative",
  "sections": [
    {
      "section_id": "string",
      "title": "string",
      "main_text": "string",
      "margin_notes": [
        {
          "note_id": "string",
          "text": "string",
          "reliability": "true|false|partial",
          "author": "original|previous_alchemist|unknown"
        }
      ],
      "illustrations": [
        {
          "type": "diagram|symbol|map|portrait",
          "description": "string",
          "reveals_information": "boolean",
          "hidden_details": "string"
        }
      ]
    }
  ]
}
```

## Sistema de Cross-References

```json
{
  "reference_id": "string",
  "source_book": "string",
  "source_section": "string", 
  "target_book": "string",
  "target_section": "string",
  "reference_type": "confirms|contradicts|elaborates|questions",
  "reliability_weight": "float (0.0-1.0)",
  "discovered_by_player": "boolean",
  "discovery_method": "explicit_citation|thematic_connection|experimental_verification"
}
```

## Tipus de Contingut

### Informació Teòrica
```json
{
  "concept_id": "string",
  "concept_name": "string",
  "explanation": "string",
  "accuracy": "accurate|misleading|partially_true|completely_false",
  "complexity_level": "basic|intermediate|advanced|master",
  "prerequisite_concepts": ["string"],
  "practical_applications": ["string"]
}
```

### Fórmules i Receptes
```json
{
  "formula_id": "string",
  "name": "string",
  "ingredients": [
    {
      "ingredient_id": "string",
      "amount": "string",
      "preparation": "string",
      "substitutions": ["string"]
    }
  ],
  "procedure": [
    {
      "step_number": "integer",
      "description": "string",
      "timing": "string",
      "conditions": "string",
      "critical_points": ["string"]
    }
  ],
  "expected_result": "string",
  "failure_modes": [
    {
      "condition": "string",
      "result": "string",
      "recovery": "string"
    }
  ],
  "accuracy": "works_as_written|requires_modification|partially_functional|completely_false"
}
```

### Descripcions de Materials
```json
{
  "material_description": {
    "material_id": "string",
    "described_name": "string",
    "physical_description": "string",
    "claimed_properties": ["string"],
    "preparation_methods": ["string"],
    "sources": ["string"],
    "accuracy_level": "accurate|exaggerated|misleading|false",
    "missing_information": ["string"],
    "dangerous_omissions": ["string"]
  }
}
```

## Sistema de Contradiccions

```json
{
  "contradiction_id": "string",
  "type": "direct_contradiction|subtle_difference|omission|emphasis",
  "books_involved": ["string"],
  "topic": "string",
  "description": "string",
  "resolution_method": "experimentation|additional_sources|logical_analysis",
  "correct_information": "string",
  "pedagogical_purpose": "string"
}
```

## Informació Amagada

```json
{
  "hidden_info": {
    "info_id": "string",
    "hiding_method": "margin_notes|cipher|acrostic|illustration_details|invisible_ink",
    "discovery_requirements": {
      "investigation_skill": "integer",
      "specific_knowledge": ["string"],
      "special_conditions": "string",
      "required_materials": ["string"]
    },
    "content": "string",
    "importance": "critical|important|interesting|flavor",
    "leads_to": ["string"]
  }
}
```

## Estats de Descobriment

### Nivells d'Accés al Contingut
1. **Closed:** Llibre no obert mai
2. **Browsed:** Obert però no llegit sistemàticament  
3. **Studied:** Llegit amb atenció, notes preses
4. **Mastered:** Comprès completament, incloent informació amagada

### Tracking del Coneixement del Jugador
```json
{
  "player_book_state": {
    "book_id": "string",
    "access_level": "closed|browsed|studied|mastered",
    "sections_read": ["string"],
    "cross_references_discovered": ["string"],
    "contradictions_noted": ["string"],
    "hidden_info_found": ["string"],
    "personal_notes": [
      {
        "note_id": "string",
        "section": "string", 
        "text": "string",
        "timestamp": "datetime"
      }
    ],
    "reliability_assessment": {
      "overall_trust": "float (0.0-1.0)",
      "section_trust": {"section_id": "float"},
      "noted_errors": ["string"]
    }
  }
}
```

## Llibres Específics del MVP

### "Manual d'Alquímia Bàsica"
```json
{
  "book_id": "basic_manual",
  "title": "Manual d'Alquímia Bàsica",
  "author": "Frère Antoine de Montpellier",
  "reliability_level": 0.3,
  "category": "introductory_trap",
  "pedagogical_purpose": "Enseñar als jugadors a no confiar en fonts òbvies",
  "major_falsehoods": [
    "L'or es pot crear escalfant plom amb sofre comú",
    "La transmutació és simple si segueixes les instruccions exactes",
    "Tots els metalls són intercamviables amb prou calor"
  ],
  "hidden_truths": [
    "Nota marginal que advirteix: 'Això no funciona - veure Llull'",
    "Pàgina arrencada que contenia la veritable fórmula"
  ]
}
```

### "Cartes de Ramon Llull"
```json
{
  "book_id": "llull_letters",
  "title": "Correspondència de Ramon Llull",
  "author": "Ramon Llull i col·laboradors",
  "reliability_level": 0.9,
  "category": "historical_authentic", 
  "pedagogical_purpose": "Font fiable per contrastar informació falsa",
  "cross_references": [
    "Corregeix errors del Manual Bàsic",
    "Confirma propietats reals del cinabri",
    "Proporciona base teòrica sòlida"
  ],
  "complexity": "Requereix coneixement previ per comprendre completament"
}
```

## API d'Accés per Godot

### Mètodes principals
```gdscript
# BookManager.gd
class_name BookManager

func get_book_content(book_id: String, player_access_level: int) -> BookContent:
    # Retorna contingut filtrat segons nivell d'accés del jugador

func discover_cross_reference(book1: String, book2: String, topic: String) -> bool:
    # Marca referència creuada com a descoberta

func mark_contradiction(book_id: String, section_id: String, type: String) -> void:
    # Registra que el jugador ha notat una contradicció

func reveal_hidden_information(book_id: String, method: String) -> Array:
    # Intenta revelar informació amagada

func assess_reliability(book_id: String, section_id: String) -> float:
    # Calcula fiabilitat basada en cross-references i experiments
```

### Events del sistema
```gdscript
signal cross_reference_discovered(book1, book2, connection)
signal contradiction_found(book_id, section_id, type)
signal hidden_info_revealed(book_id, info_type, content)
signal reliability_updated(book_id, new_level, reason)
```

## Validació i Consistency

### Regles de Validació
- Tots els cross-references han de tenir contrapart
- Les contradiccions han de tenir resolució possible
- Informació crítica mai pot dependre d'una sola font
- False leads han de tenir pistes de la seva falsedat

### Tools de Desenvolupament
- Editor per crear i modificar llibres
- Validator per detectar inconsistències  
- Cross-reference mapper per visualitzar connexions
- Difficulty balancer per ajustar false leads

---

Aquest esquema garanteix que els llibres funcionin com a eina d'investigació complexa que requereix pensament crític i contrastar fonts múltiples.

---

Torna a [[SistemaDades/arquitectura|Arquitectura del Sistema]]