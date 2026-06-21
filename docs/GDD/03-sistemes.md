# Sistemes Principals

El joc **Dimonis** es construeix sobre 4 sistemes interconnectats que implementen els [[GDD/02-pilars|pilars de disseny]]. Cada sistema té un propòsit específic i interactua amb els altres per crear l'experiència d'investigació alquímica.

## Sistema 1: La Biblioteca 📚

### Propòsit
Centre d'informació i investigació. Conté el coneixement necessari per identificar objectes i comprendre l'alquímia.

### Mecàniques Clau

#### Textos Distribuïts
- **Llibres principals:** Contenen informació "òbvia" que sovint és incompleta o falsa
- **Notes marginals:** Aquí es troben les veritables pistes i correccions
- **Documents fragmentats:** Cartes, diaris, papirs antics amb informació dispersa

#### Sistema de Lectures Creuades
- **Referències internes:** Els textos es referencien mútuament
- **Contradiccions deliberades:** Diferents fonts donen informació conflictiva
- **Verificació necessària:** La informació ha de ser contrastada via experimentació

#### Exemple de Funcionalitat
```
Llibre: "Tractatus de Auro" 
- Text principal: "L'or es crea escalfant plom amb sofre"
- Nota marginal: "Fals! Veure els apunts de Llull sobre el mercuri"
- Referència creuada: Porta a un altre llibre amb la fórmula real
```

### Integració amb Altres Sistemes
- Informa el [[#Sistema 3: El Laboratori|Laboratori]] sobre experiments possibles
- Ajuda a identificar objectes del [[#Sistema 2: El Compendi|Compendi]]
- Proporciona pistes per progressar a la [[#Sistema 4: La Torre|Torre]]

## Sistema 2: El Compendi 📋

### Propòsit
Registre personal d'objectes identificats i els seus usos coneguts.

### Estat Inicial: BUIT COMPLET
- **Problema del joc tradicional:** Els jugadors poden consultar wikis o fer força bruta
- **Solució de Dimonis:** El compendi reflecteix només el que el JUGADOR ha descobert

### Mecàniques Clau

#### Estats d'Objectes
1. **Desconegut:** "Pedra vermella", "Pols groga", "Líquid viscós"
2. **Parcialment identificat:** "Sembla cinabri (no confirmat)"
3. **Completament identificat:** "Cinabri - Sulfur de mercuri. Utilitzat per transmutació lunar"

#### Procés d'Identificació
1. **Observació:** Examen visual bàsic (color, textura, pes)
2. **Investigació:** Consulta de llibres i comparació amb descripcions
3. **Verificació:** Experiments simples de confirmació
4. **Comprensió completa:** Experiments avançats que revelen totes les propietats

#### Sistema de Confiança
- Cada entrada té un nivell de certesa: `uncertain`, `probable`, `confirmed`
- Els experiments poden fallar si uses informació `uncertain`
- Només les entrades `confirmed` es poden usar en fórmules complexes

### Exemple d'Evolució d'una Entrada

**Fase 1 - Troballa:**
```
ID: unknown_rock_01
Nom: "Pedra vermella"
Descripció: "Pedra pesada de color vermell intens"
Estat: unknown
```

**Fase 2 - Investigació:**
```
ID: unknown_rock_01  
Nom: "Possible cinabri"
Descripció: "Pedra vermella pesada. Segons Llull, el cinabri és vermell i dens."
Estat: partial
Confiança: uncertain
```

**Fase 3 - Identificació completa:**
```
ID: cinabri_001
Nom: "Cinabri"
Descripció: "Sulfur de mercuri (HgS). Utilitzat per obtenir mercuri pur mitjançant calcinació."
Estat: identified
Confiança: confirmed
Propietats: [mercurial, sulfurós, lunar]
Experiments_possibles: [calcinació_mercuri, transmutació_lunar]
```

## Sistema 3: El Laboratori ⚗️

### Propòsit
Espai d'experimentació on s'identifiquen objectes i es creen noves substàncies.

### Tipus d'Experiments

#### Experiments d'Identificació
- **Objectiu:** Identificar objectes desconeguts
- **Mètodes:** Calcinació, dissolució, destil·lació, observació microscòpica
- **Resultat:** L'objecte passa d'`unknown` a `identified`

#### Experiments de Síntesi
- **Objectiu:** Crear noves substàncies
- **Requisits:** Tots els ingredients han d'estar completament identificats
- **Risc de fallada:** Si uses ingrediets mal identificats, l'experiment falla

#### Experiments de Verificació
- **Objectiu:** Comprovar informació trobada als llibres
- **Funció:** Canviar la confiança d'una entrada de `uncertain` a `confirmed`

### Mecànica de Fallades

#### Estats d'Experiment
1. **Èxit complet:** Obtens el resultat esperat
2. **Èxit parcial:** Obtens pistes addicionals però no el resultat final
3. **Fallada informativa:** L'experiment falla però aprens per què
4. **Fallada destructiva:** Perds ingredients i no aprens res nou

#### Factors que Afecten l'Èxit
- **Precisió dels ingredients:** Objectes mal identificats causen fallades
- **Seguiment de procediments:** Les instruccions dels llibres han de seguir-se exactament
- **Condicions ambientals:** Alguns experiments requereixen condicions específiques (lua plena, temperatures...)

### Sistema de Cross-Referencing
- Els experiments exitosos donen informació que es pot contrastar amb els llibres
- Les fallades poden indicar que la informació d'un llibre és incorrecta
- Aquest sistema permet distinguir fonts fiables de fonts falsas

## Sistema 4: La Torre 🗼

### Propòsit
Estructura física que conté tots els altres sistemes i es va desbloquejant gradualment.

### Progressió Vertical

#### Planta Baixa - Sempre Accessible
- **Biblioteca bàsica:** Llibres introductoris i notes del predecessor
- **Laboratori simple:** Equips bàsics per experiments d'identificació
- **Compendi inicial:** On el jugador comença a registrar descobriments

#### Primer Pis - Requereix Clau de Bronze
- **Biblioteca avançada:** Textos més especialitzats i esotèrics
- **Laboratori millorat:** Equips per experiments de síntesi
- **Observatori lunar:** Per experiments que requereixen fases lunars específiques

#### Segon Pis - Requereix Clau de Plata  
- **Arxiu secret:** Documents personals de l'alquimista anterior
- **Laboratori màgic:** Equips per a la veritable transmutació
- **Cambra de meditació:** Accés als aspectes espirituals de l'alquímia

#### Tercer Pis - Requereix Clau d'Or
- **Sanctum sanctorum:** Els secrets més profunds
- **Opus Magnus:** L'equip per al treball alquímic més elevat
- **Portal dimensional:** Accés als realms dels [[Lore/Entitats/_index|dimonis alquímics]]

### Sistema de Claus
- **Clau de Bronze:** S'obté identificant correctament 10 materials bàsics
- **Clau de Plata:** S'obté completant el primer ritual de transmutació
- **Clau d'Or:** S'obté demostrant comprensió dels principis hermètics profunds

---

## Interacció entre Sistemes

### Flux de Joc Típic
1. **Explora** la Torre i troba objectes desconeguts
2. **Consulta** la Biblioteca per obtenir pistes sobre la seva identitat
3. **Experimenta** al Laboratori per identificar-los
4. **Registra** al Compendi els resultats confirmats
5. **Utilitza** els objectes identificats per accedir a noves àrees de la Torre

### Bucles de Feedback
- Cada sistema informa els altres
- Cap sistema és completament independent
- La progressió requereix dominar la interacció entre tots quatre

---

Següent: [[GDD/04-progressio|Progressió del Joc]] | Anterior: [[GDD/02-pilars|Pilars de Disseny]]