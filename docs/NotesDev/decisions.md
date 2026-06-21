# Log de Decisions de Disseny

Aquest document registra totes les decisions majors de disseny preses durant el desenvolupament de **Dimonis**, incloent el context, alternatives considerades, i raons per la decisió final.

---

## Decisions de Mecàniques Centrals

### DECISIÓ #001: Compendi Inicialment Buit
**Data:** 20 juny 2026  
**Context:** Debate sobre com prevenir que els jugadors consultin wikis externes o facin force bruta als experiments

**Alternatives considerades:**
1. **Compendi pre-omplert:** Tots els materials visibles des del principi, però locked fins identificar-los
2. **Compendi parcialment omplert:** Alguns materials coneguts, altres descobribles  
3. **Compendi completament buit:** Cap informació visible fins identificació completa
4. **Sistema híbrid:** Informació bàsica visible, detalls avançats requereixen identificació

**Decisió:** Compendi completament buit (opció 3)

**Raonament:**
- Garanteix que el descobriment sigui autèntic - no pots cercar el que no saps que existeix
- Elimina completament la possibilitat de force bruta en experiments
- Crea una sensació genuïna de descobriment quan identifiques correctament un material
- Força el jugador a prendre notes físiques perquè no pot confiar en el compendi

**Trade-offs acceptats:**
- Majors barriers d'entrada - alguns jugadors es poden sentir perduts inicialment
- Més dificultat per players amb problemes de memòria
- Requereix tutorial més gradual i cuidadós

**Mètrica d'èxit:** >75% dels jugadors expressen satisfacció amb el seu primer descobriment "real"

---

### DECISIÓ #002: False Leads com a Mecànica Central
**Data:** 20 juny 2026  
**Context:** Necessitat de recompensar la investigació profunda per sobre de seguir instruccions òbvies

**Alternatives considerades:**
1. **Cap false lead:** Tota informació és correcta però complexa
2. **False leads accidentals:** Informació incorrecta no intencional per raons de gameplay
3. **False leads menors:** Alguns errors menors en fonts menys fiables
4. **False leads sistèmics:** Pistes òbvies condueixen sistemàticament a trampes

**Decisió:** False leads sistèmics (opció 4)

**Raonament:**
- Ensenya als jugadors a ser escèptics i contrastar fonts múltiples
- Recompensa la curiositat i la investigació lateral
- Reflecteix la realitat històrica - moltes fonts alquímiques eren deliberadament enganyoses
- Augmenta dràsticament la rejugabilitat quan els jugadors descobreixen que s'havien equivocat

**Implementació específica:**
- Els llibres més "òbvius" contenen les trampes més elaborades
- Les correccions es troben en notes marginals, documents fragmentaris, o experiments
- Els finals falsos són recompensants a curt termini però insatisfactoris a llarg termini

**Risc mitiant:** Tutorial explícit sobre la necessitat de contrastar fonts

---

### DECISIÓ #003: Quadern Físic com a Element Central
**Data:** 18 juny 2026  
**Context:** Debate sobre accessibilitat vs. experiència d'immersió única

**Alternatives considerades:**
1. **Només digital:** Tot el note-taking dins del joc
2. **Físic opcional:** Recomanat però amb alternativa digital completa
3. **Físic core + alternativa:** Dissenyat per físic, alternativa per accessibilitat
4. **Físic obligatori:** Cap alternativa digital

**Decisió:** Físic core + alternativa (opció 3)

**Raonament:**
- El quadern físic és part integral de l'experiència d'investigació alquímica
- Escribir a mà força una connexió més profunda amb el descobriment
- Disconnect de la pantalla augmenta la immersió en el món històric
- Tanmateix, accessibilitat és important per jugadors amb limitacions

**Implementació:**
- Joc dissenyat assumint ús de quadern físic
- Alternatives digitales disponibles però marcades com "mode assistit"
- Quadern oficial dissenyat especialment per al joc amb plantilles útils
- Suport per apps de notes externes per jugadors que ho prefereixen

**Compromís:** No sacrificar la visió central per accessibilitat universal, però proporcionar alternatives raonables

---

## Decisions d'Abast i Contingut

### DECISIÓ #004: 3 Finals pel MVP (Reducció des de 7)
**Data:** 20 juny 2026  
**Context:** Necessitat de concentrar recursos per assegurar qualitat alta

**Finals seleccionats:**
1. **El Pont entre Mons:** Final vertader que requereix equilibri i comprensió profunda
2. **L'Emperador de la Matèria:** Final fals per jugadors obsessionats amb poder material
3. **El Col·leccionista Etern:** Final fals per jugadors obsessionats amb completesa

**Finals desartats per MVP:**
- L'Alquimista Perfecte (massa similar a Emperador)
- La Transcendència (requereix contingut espiritual massa complex)
- El Camí de l'Oblit (massa fosc pel tone del MVP)
- El Mestre dels Dimonis (requereix sistema d'entitats massa complex)

**Criteris de selecció:**
- Diversitat d'aproximacions filosòfiques
- Facilitat d'implementació tècnica
- Potencial educatiu sobre la natura de l'alquímia
- Adequació per audiences del MVP

**Mètrica d'èxit:** Cada final escollit per almenys 25% dels jugadors en el primer mes

---

### DECISIÓ #005: 26 Materials pel MVP
**Data:** 21 juny 2026  
**Context:** Equilibrar profunditat vs. amplitud per l'experiència inicial

**Categories incloses:**
- **7 metalls planetaris:** Cobertura completa de la tradició clàssica
- **8 minerals especials:** Inclou cinabri, vitriols, antimoni per experiments avançats
- **6 herbes alquímiques:** Representació de categories elementals i planetàries
- **3 materials orgànics:** Alum, càmfor, múmia alquímica per diversitat
- **2 substàncies preparades:** Mercuri i sofre filosòfics com a objectius avançats

**Materials descartats per MVP:**
- Cristalls de poder (requereixen sistema dimensional)
- Materials temporals (requereixen sistema de temps complex)
- Essències elementals (massa abstractes per començament)
- Materials de creature (requereixen sistema de besties)

**Raonament:** 26 materials proporcionen suficient contingut per 8-10 hores de descobriment sense sobrecarregar el desenvolupament

---

## Decisions Tècniques

### DECISIÓ #006: Godot 4 com a Engine Principal
**Data:** 15 juny 2026  
**Context:** Selecció d'engine per desenvolupament

**Alternatives considerades:**
- **Unity:** Familiar però licensing concerns
- **Unreal:** Potent però overkill per aquest projecte
- **Godot 4:** Open source, adequat per projecte indie
- **Custom engine:** Màxim control però development time prohibitiu

**Decisió:** Godot 4

**Raonament:**
- Open source elimina licensing concerns per project indie
- GDScript és adequat per gameplay complexity sense ser overwhelming
- 2D/3D hybrid support adequat per aesthetic planificat
- Community support creixent i engine maturing ràpidament
- C# integration disponible per components performance-crítics

**Trade-offs:** Learning curve per team, menys third-party tools que Unity

---

### DECISIÓ #007: Separació de Dades Reals vs. Coneixement del Jugador
**Data:** 21 juny 2026  
**Context:** Arquitectura per suportar descobriment gradualment revelat

**Arquitectura escollit:**
```
ObjectDatabase (hidden) -> KnowledgeFilter -> PlayerInterface
```

**Alternatives considerades:**
1. **Single source:** Tot en una database, filtrat a runtime
2. **Dual database:** Database real + database del jugador separades
3. **Layered approach:** Multiple capes de filtrat segons niveau de coneixement
4. **Event-driven:** Database canvia segons esdeveniments de descobriment

**Decisió:** Layered approach (opció 3) amb elements de dual database

**Benefits:**
- Prevenció absoluta de data leakage al jugador
- Fàcil modificació del nivell de detail sense canviar core data
- Support natural per multiple knowledge states
- Debug capabilities per developers sense comprometre player experience

**Complexitat adicional:** Requereix careful management de consistency entre layers

---

## Decisions de Narrativa i Lore

### DECISIÓ #008: Focus en Tradició Alquímica Catalana
**Data:** 16 juny 2026  
**Context:** Necessitat de diferenciació cultural i autenticitat històrica

**Raonament per Catalunya específicament:**
- Ramon Llull és figura fonamental però subrepresentada en gaming
- Tradició hermètica catalana té characteristic uniques (combinatorics, etc.)
- Permet diferenciació de games centrats en alquímia europea general
- Background del team amb coneixement específic d'història catalana

**Elements específics integrats:**
- Manuscripts de Ramon Llull com a fonte central d'autoritat
- Geografia de Catalunya amb llocs històrics reals
- Tradició del Monestir de Pedralbes amb manuscripts alquímics
- Influència del pensament andalusí en Catalunya medieval

**Beneficis realitzats:**
- Autenticitat històrica verificable
- Narrativa distinctive que no s'ha explorat en gaming
- Potential per educational partnerships amb institucions catalanes

---

### DECISIÓ #009: L'Alquimista Anterior com a Mentor Absent
**Data:** 18 juny 2026  
**Context:** Necessitat de guidance pel jugador sense eliminar sensació de descobriment independent

**Character concept:** Mestre que ha transcendit físicament però deixa la Torre i el seu coneixement per al següent

**Alternatives considerades:**
1. **Mentor present:** NPC disponible per consultació directa
2. **Mentor absent permanent:** Cap guidance, descobriment complet independent
3. **Mentor gradual:** Apareix més segons progressió del jugador
4. **Mentor threshold:** Només disponible en moments crítics específics

**Decisió:** Hybrid de threshold + gradual (opcions 3-4)

**Implementation:**
- Notes i diaris proporcionen guidance inicial
- Apareix com visió/veu en moments de dubte significatiu
- Mai dona respostes directes, només pistes per dirigir investigació
- Més accessible segons jugador demostra respecte per l'Arte

**Balanç aconseguit:** Support suficient per evitar frustració, independència suficient per mantenir ownership del descobriment

---

## Decisions d'Experiència d'Usuari

### DECISIÓ #010: Tutorial Implicit vs. Explicit
**Data:** 19 juny 2026  
**Context:** Com ensenyar mechanics complexos sense trencar immersion

**Decisió:** Tutorial implicit amb safety net explícit

**Implementation:**
- Primeres 2 hores dissenyades per natural discovery de mechanics
- Objectes inicials escollits per ser relativament fàcils d'identificar
- Llibres inicials contenen guidance sobre methodology general
- Hints system disponible però marcat com "consulta d'aprenent"
- Failure recovery sempre possible - cap dead-end permanent

**Raonament:** 
- Target audience prefereix descobrir per si mateixos
- Tutorials explícits trenquen la immersion en món historic
- Safety net necessari per evitar frustració que porta a abandonament

**Success metric:** >80% players completen primer descobriment sense usar hints

---

## Decisions de Monetització

### DECISIÓ #011: Premium Single-Purchase Model
**Data:** 17 juny 2026  
**Context:** Model de monetització per project indie amb target educated

**Alternatives considerades:**
1. **Free-to-play + IAP:** Amplia audience però pot comprometre design integrity
2. **Subscription:** Recurring revenue però barrier alt per indie game
3. **Premium purchase:** Single price adequat per experiència completa
4. **Episodic:** Multiple releases més petits

**Decisió:** Premium purchase amb DLC episòdic planificat

**Price point:** €24.99 per MVP, €9.99 per expansion major

**Raonament:**
- Target audience té purchasing power adequat
- Single purchase respecta la natura artística del project
- No incentiva predatory mechanics o grind artificial
- DLC model permet expansion sense fragmentar core experience

**Additional revenue streams:**
- Quaderns oficials físics
- Merchandising educatiu (eines alquímiques replica)
- Consultoria educativa per institucions

---

## Retrospectiva de Decisions

### Decisions que han Funcionat Bé
- **Compendi buit:** Early testing confirma que crea discovery moment autèntics
- **False leads:** Beta testers reporta que això els fa pensar more critically
- **Lore català:** Experts historian confirma authenticity i uniqueness

### Decisions que Requereixen Monitorització  
- **Quadern físic:** Encara hem de validar amb broader audience
- **Tutorial implicit:** Pot ser massa difficult per some players
- **Performance de layered data architecture:** Necessita testing amb data real

### Decisions que Podrien Canviar
- **Nombre de materials MVP:** Pot ser massa per primera iteració
- **Complexity dels experiments:** Pot requerir simplificació per accessibility
- **Timeline del MVP:** Pot ser optimistic given scope actual

---

*Aquest document es manté actualitzat amb cada decisió major de disseny*

---

Torna a l'[[_index|índex principal de la volta]]