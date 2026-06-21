# Pilars de Disseny

Aquests són els 5 pilars fonamentals que guien totes les decisions de disseny de **Dimonis**. Cap característica o mecànica pot contradir aquests principis.

## Pilar 1: Descobriment Autèntic 🔍

**Principi:** El coneixement és progressió. Els jugadors avancen descobrint, no acumulant.

### Mecànica Central: Sistema d'Identificació
- **Estat inicial:** El [[Lore/Materials/_index|compendi]] comença completament buit
- **Objectes desconeguts:** Tot element trobat apareix com "objecte desconegut" fins ser identificat
- **Procés d'identificació:** Requereix investigació + experimentació + lectures creuades
- **Prevenció de força bruta:** No pots usar el que no saps que és

### Implementació
- Els objectes tenen un `identification_state`: `unknown`, `partial`, `identified`
- Només els objectes `identified` apareixen al compendi amb nom i propietats reals
- Els experiments falles si uses objectes no identificats

**Exemple:** Trobes una "pedra vermella". Fins que no la identifiquis com a "Cinabri" mitjançant llibres i proves, no la pots usar en experiments avançats.

## Pilar 2: Falses Pistes com a Mecànica 🕳️

**Principi:** Les pistes òbvies condueixen a trampes. Els veritables secrets estan fora del camí marcat.

### Sistema de Breadcrumbs Falsos
- **Pistes primàries:** Sempre condueixen a finals no-verdaders o informació incompleta
- **Camins secrets:** Els finals verdaders requereixen investigació lateral i connexions no òbvies
- **Recompensa la curiositat:** Els jugadors que dubten de l'obvi troben més contingut

### Exemple d'Implementació
- Un llibre "obvi" sobre transmutació d'or condueix a un final fals on "descobreixes" una fórmula que no funciona
- El veritable secret de l'or està en notes marginals d'un llibre de botànica aparentment no relacionat

## Pilar 3: El Quadern com a Eina Central 📔

**Principi:** La investigació real requereix documentació real. El joc no ho fa tot per tu.

### Filosofia d'Accessibilitat Indie
- **Posició clara:** Aquest és un joc indie que no sacrifica la visió per accessibilitat universal
- **Quadern físic:** És la experiència recomanada i dissenyada
- **Alternatives suggerides:** Per qui ho necessiti, però sense comprometre el disseny core

### Integració Mecànica
- Informació crítica apareix només temporalment o dispersa
- Cap sistema intern de notes automàtic
- Els patrons i connexions han de ser descoberts pel jugador

## Pilar 4: Consistència Alquímica ⚗️

**Principi:** Tot element del joc segueix les regles de l'alquímia clàssica i la filosofia hermètica.

### Sistema de Regles Consistent
- **Correspondències:** Planetes, metalls, elements segueixen tradicions històriques
- **Simbolisme coherent:** Cada símbol i associació té base en alquímia real
- **Lògica interna:** Les fórmules i experiments segueixen principis hermètics autèntics

### Referències Històriques
- Textos de Paracelso, Ramon Llull, Nicolas Flamel
- Tradició alquímica catalana i mediterrània
- Simbolisme astrològic i hermètic tradicional

## Pilar 5: Narrativa Emergent 📖

**Principi:** La història sorgeix de la investigació. No hi ha cutscenes o explicacions directes.

### Descobriment Gradual
- **Lore distribuït:** La història està fragmentada en llibres, notes, experiments
- **Connexions del jugador:** Les revelacions vénen de connectar informació dispersa
- **Múltiples interpretacions:** Diferents jugadors poden arribar a conclusions diferents

### Estats de Coneixement
- **Ignorància:** Només fas experiments bàsics
- **Comprensió parcial:** Comences a veure patrons
- **Il·luminació:** Entens els principis profunds i pots accedir als finals verdaders

---

## Interacció entre Pilars

Aquests pilars no són independents - treballen junts:

1. **Descobriment + Falses pistes:** No pots forçar la investigació perquè les pistes òbvies et desorienten
2. **Quadern + Narrativa:** Prendre notes físiques et permet trobar connexions que el joc no et dona
3. **Consistència + Descobriment:** La lògica alquímica real recompensa el coneixement autèntic
4. **Tots junts:** Creen una experiència d'investigació profunda i recompensant

---

Següent: [[GDD/03-sistemes|Sistemes Principals]] | Anterior: [[GDD/01-visio|Visió i Objectius]]