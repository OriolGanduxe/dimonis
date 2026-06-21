# Dimonis - Joc d'Investigació Alquímica

**Dimonis** és un joc d'investigació narrativa on heretes la torre misteriosa d'un alquimista desaparegut. Descobreix els secrets de l'alquímia mitjançant la investigació de textos antics, la identificació d'ingredients desconeguts i l'experimentació al laboratori.

## Característiques Principals

- **Descobriment Autèntic**: El coneixement és progressió. Els objectes comencen desconeguts i has d'identificar-los mitjançant investigació real.
- **Sistema de Falses Pistes**: Les pistes òbvies sovint condueixen a camins sense sortida. Només la investigació minuciosa revela els veritables secrets.
- **Investigació amb Quadern**: Recomana prendre notes físiques per trobar connexions que el joc no et dona automàticament.
- **Alquímia Històrica**: Basat en textos i tradicions alquímiques reals dels segles XIV-XVI.

## Arquitectura Tècnica

El projecte està estructurat seguint **Clean Architecture** + **SOLID**:

```
scripts/
├── core/             # Domain layer - lògica de negoci
├── data/             # Data layer - recursos i persistència  
└── presentation/     # Presentation layer - UI i controls
```

### Sistema de Dades (Data-Driven)

Tot el contingut està en fitxers de dades (JSON/Resources) per facilitar modificacions:

- **Llibres**: `data/books/` - Contingut amb informació contradictòria i falses pistes
- **Experiments**: `data/experiments/` - Definicions d'experiments amb validació de materials
- **Compendi**: Generat dinàmicament segons descobriments del jugador
- **Save Games**: Estat complet del coneixement i progrés del jugador

## Estructura del Projecte

```
Dimonis/
├── project.godot
├── export_presets.cfg    # Configuració per export web
├── assets/
│   ├── fonts/
│   └── ui/
├── scenes/
│   ├── main/             # Escena principal
│   ├── tower/            # Navegació de la torre
│   ├── rooms/            # Biblioteca, Laboratori, etc.
│   ├── ui/               # Interfaces d'usuari
│   └── entities/         # Objectes del joc
├── scripts/
│   ├── core/             # GameManager, PlayerKnowledgeManager
│   ├── data/             # Resources (BookResource, ExperimentResource, etc.)
│   └── presentation/     # Controllers d'UI
├── data/
│   ├── books/            # Definicions de llibres en JSON
│   ├── compendium/       # Templates d'entrades del compendi
│   ├── experiments/      # Definicions d'experiments
│   └── dialogues/        # Diàlegs amb entitats
└── exports/
    └── web/              # Build per GitHub Pages
```

## Sistema de Descobriment

### Estats d'Identificació d'Objectes

1. **Unknown**: Objecte trobat però no identificat ("Pedra vermella")
2. **Suspected**: Hipòtesi basada en investigació ("Possiblement cinabri")
3. **Partial**: Identificació parcial confirmada ("Cinabri impure")
4. **Confirmed**: Identitat completa amb totes les propietats

### Mecànica Central: No Força Bruta

- Els experiments fallen si uses materials no identificats correctament
- Cal investigar llibres i contrastar fonts múltiples
- La informació òbvia sovint és incorrecta o incompleta

## Desenvolupament

### Requisits

- **Godot 4.7-stable**: Motor del joc
- **Git**: Control de versions
- **Navegador modern**: Per testing de la versió web

### Configuració per Desenvolupament

1. Clona el repositori:
   ```bash
   git clone https://github.com/OriolGanduxe/dimonis.git
   cd dimonis
   ```

2. Obre amb Godot 4.7+:
   ```bash
   ~/godot/Godot_v4.7-stable_linux.arm64 --path .
   ```

3. Executa l'escena `scenes/main/Main.tscn`

### Export per Web (GitHub Pages)

El projecte està configurat per export automàtic a web:

```bash
# Export manual
godot --headless --export-release "Web" exports/web/index.html

# O des de l'editor: Project > Export > Web
```

### Estructura de Clean Architecture

```
┌─────────────────┐
│   Presentation  │  ← UI, Controls, Escenes
├─────────────────┤
│      Core       │  ← Lògica de negoci, Managers
├─────────────────┤
│      Data       │  ← Resources, Persistència
└─────────────────┘
```

**Principis**:
- **Dependency Inversion**: Core no depèn de Data o Presentation
- **Single Responsibility**: Cada manager té una responsabilitat única
- **Open/Closed**: Fàcil afegir nous tipus de llibres/experiments sense modificar codi existent

## Contingut del MVP

### Llibres Implementats

- **Manual d'Alquímia Bàsica**: Llibre "trampa" amb informació falsa
- **Correspondència de Ramon Llull**: Font fiable per contrastar informació

### Experiments Implementats

- **Prova de Flama Bàsica**: Identificació de materials per color de combustió

### Funcionalitats Principals

- [x] Sistema de compendi amb identificació gradual
- [x] Càrrega de llibres des de JSON
- [x] Sistema d'experiments amb validació de materials
- [x] Save/Load amb integritat de dades
- [x] Export a web per GitHub Pages
- [ ] UI completa per biblioteca i laboratori
- [ ] Sistema de falses pistes implementat
- [ ] Múltiples finals segons descobriments

## Filosofia de Disseny

### Els 5 Pilars

1. **Descobriment Autèntic**: El coneixement és l'única progressió
2. **Falses Pistes**: Les solucions òbvies són trampes
3. **Quadern Físic**: La investigació real requereix documentació real
4. **Consistència Alquímica**: Tot segueix principis hermètics històrics
5. **Narrativa Emergent**: La història sorgeix de la investigació

### Públic Objectiu

Jugadors que gaudeixen de:
- Investigació profunda i deducció
- Prendre notes i descobrir patrons
- Narrativa emergent i descobriment gradual
- Sistemes complexos amb lògica interna consistent

## Contribució

Aquest és un projecte indie amb visió específica. Les contribucions han de respectar els pilars de disseny i l'arquitectura establerta.

### Guidelines

- Respectar Clean Architecture (no mesclar layers)
- Tot contingut nou ha de ser data-driven (JSON/Resources)
- Mantenir consistència amb alquímia històrica
- Provar canvis amb el sistema d'identificació gradual

## Llicència

[Per definir - Probablement Creative Commons o similar per contingut cultural]

---

**"L'art alquímic no rau en la fórmula, sinó en la comprensió"**  
*— Inspirat en Ramon Llull*