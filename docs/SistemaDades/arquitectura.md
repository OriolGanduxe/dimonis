# Arquitectura del Sistema de Dades

## Filosofia del Sistema

El sistema de dades de **Dimonis** està dissenyat per suportar el [[GDD/02-pilars#Pilar 1: Descobriment Autèntic|sistema de descobriment autèntic]] com a mecànica central. Els objectes existeixen amb identitats ocultes que s'han de revelar mitjançant la investigació.

## Principis de Disseny

### 1. Identitat Gradualment Revelada
- Cada objecte té múltiples capes d'informació
- La informació es desbloqueja segons el nivell de coneixement del jugador
- Les propietats "reals" són diferents de l'aparença inicial

### 2. Estats de Coneixement
- **Unknown:** L'objecte existeix però la seva identitat és desconeguda
- **Suspected:** Hipòtesi sobre la identitat basada en observacions
- **Partial:** Identificació parcial confirmada per experiments  
- **Confirmed:** Identitat completa amb totes les propietats conegudes

### 3. Cross-Referencing Obligatori
- Cap font única d'informació és completament fiable
- Els jugadors han de contrastar múltiples fonts
- Experiments serveixen per verificar informació dels llibres

---

## Arquitectura General

### Base de Dades Principal
```
GameDatabase/
├── WorldState/          # Estat del món i Torre
├── PlayerKnowledge/     # Coneixement descobert pel jugador
├── ObjectCatalog/       # Tots els objectes possibles (ocultat al jugador)
├── BookLibrary/         # Contingut de tots els llibres
├── ExperimentHistory/   # Historial d'experiments realitzats
└── SaveStates/          # Partides guardades
```

### Separació de Dades
**Crítica:** Les dades "reals" dels objectes mai s'exposen directament al jugador. Només es mostren a través del filtre del seu nivell de coneixement actual.

### Sistema de Queries
Totes les consultes de dades passen per una capa de filtrat que:
1. Comprova el nivell de coneixement del jugador sobre l'objecte
2. Decideix quina informació mostrar segons l'estat actual
3. Aplica falses pistes si escau

---

## Components Principals

### 1. ObjectIdentificationSystem
Gestiona el procés de descobriment i identificació d'objectes.

**Responsabilitats:**
- Assignar identificadors temporals a objectes no identificats
- Gestionar transicions entre estats de coneixement
- Aplicar falses identificacions quan cal

**Estats possibles:**
```json
{
  "identification_state": "unknown|suspected|partial|confirmed",
  "confidence_level": 0.0-1.0,
  "player_assigned_name": "Pedra vermella",
  "suspected_identity": "cinabri",
  "confirmed_properties": [],
  "false_leads_followed": []
}
```

### 2. BookCrossReferenceSystem
Connecta informació entre diferents fonts i gestiona contradiccions.

**Funcionalitats:**
- Detectar referències creuades entre llibres
- Marcar informació contradictòria
- Gestionar fonts fiables vs no-fiables

### 3. ExperimentValidationSystem  
Simula experiments i determina resultats segons el coneixement actual.

**Mecànica:**
- Els experiments fallen si uses objectes mal identificats
- Els resultats varien segons la precisió de la identificació
- Alguns experiments revelen nova informació sobre objectes

### 4. FalseBreadcrumbSystem
Implementa el [[GDD/02-pilars#Pilar 2: Falses Pistes com a Mecànica|sistema de falses pistes]].

**Estratègies:**
- Informació obviament incorrecta per detectar jugadors que no investigen
- Semicerteses que funcionen parcialment però fallen en usos avançats  
- Camins plausibles que condueixen a finals no-verdaders

---

## Fluxos de Dades Principals

### Flux de Descobriment d'Objectes
1. **Troballa:** Objecte apareix amb descripció genèrica
2. **Observació:** Jugador examina propietats físiques bàsiques
3. **Investigació:** Consulta llibres per pistes sobre identitat
4. **Experimentació:** Proves per confirmar o descartar hipòtesis
5. **Identificació:** Objecte canvia a estat "confirmed" amb propietats reals

### Flux de Validació d'Informació
1. **Font inicial:** Jugador troba informació en un llibre
2. **Cross-check:** Sistema comprova si altres fonts confirmen/contradiuen
3. **Experiment:** Jugador intenta verificar amb proves pràctiques
4. **Resultat:** Confirma, desmenteix, o proporciona informació parcial

### Flux de False Leads
1. **Trigger:** Jugador segueix pista òbvia sense investigació profunda
2. **Progressió falsa:** Sistema permet progressió aparent
3. **Revelació:** En punt crític, es revela que el camí és fals
4. **Redirection:** Pistes subtils cap al camí correcte

---

## Persistència i Save System

### Estructura de Partida Guardada
```json
{
  "player_knowledge": {
    "identified_objects": {},
    "book_content_read": {},
    "experiments_performed": {},
    "false_leads_discovered": {},
    "current_theories": {}
  },
  "world_state": {
    "tower_access_level": 1,
    "available_objects": {},
    "library_content": {},
    "time_based_events": {}
  },
  "progression": {
    "current_phase": 1,
    "keys_obtained": [],
    "milestones_achieved": [],
    "endings_unlocked": []
  }
}
```

### Versionat de Dades
- Sistema de migrations per actualitzacions del joc
- Backward compatibility per partides existents
- Detecció de save corruption i recovery procedures

---

## Integració amb Godot

### Arquitectura MVC
- **Model:** Classes de dades pures (C#)  
- **View:** Escenes Godot amb UI responsiva
- **Controller:** Scripts GDScript que conecten Model i View

### Gestió d'Estats
```gdscript
# Singleton per gestionar l'estat global del coneixement
extends Node

class_name PlayerKnowledgeManager

var identified_objects = {}
var book_discoveries = {}
var experiment_history = []
var current_theories = {}

func reveal_object_property(object_id: String, property: String) -> bool:
    # Lògica per revelar propietat segons nivell actual de coneixement
```

### Event System
Sistema d'esdeveniments per comunicar canvis d'estat:
- `object_identified(object_id, new_state)`
- `false_lead_detected(path, correction)`  
- `experiment_completed(result, new_knowledge)`
- `cross_reference_discovered(book1, book2, connection)`

---

## Performance i Optimització

### Lazy Loading
- Contingut de llibres es carrega només quan s'accedeix
- Dades d'objectes no identificats es mantenen mínimes
- Experiment simulations calculen-se on-demand

### Caching Strategy
- Results d'experiments es cached per evitar recàlculs
- Cross-references pre-calculats per consulta ràpida
- Player knowledge indexat per queries eficients

### Memory Management
- Unload automàtic de contingut no utilitzat
- Compression de save files per minimitzar espai
- Garbage collection adequat per llargues sessions

---

## Testing i Validació

### Unit Testing
- Tests per cada component del sistema d'identificació
- Validació de consistency en cross-references
- Simulació de false leads per assegurar que funcionen

### Integration Testing  
- Tests end-to-end del flux complet de descobriment
- Validació que els experiments donen resultats consistents
- Verificació que save/load preserva l'estat correctament

### Player Experience Testing
- Verificar que els false leads no són frustrànement obvios
- Assegurar que el cross-referencing proporciona pistes adequades
- Confirmar que la progressió se sent recompensant

---

Aquesta arquitectura suporta els [[GDD/02-pilars|pilars de disseny]] garantint que el descobriment sigui autèntic, les falses pistes funcionin correctament, i el sistema escali per contingut post-MVP.

---

Torna a l'[[_index|índex principal de la volta]]