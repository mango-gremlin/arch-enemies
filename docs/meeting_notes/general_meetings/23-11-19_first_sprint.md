---
startTime: 12:00
endTime: 13:30
---
# Teammeeting | erster Sprint (W46)
anchored to [[113.00_anchor]]
[Date:2023-11-19]

Protokollant\*in: Evelyn
geleitet von: Mara
Anwesend: _alle_
- Aylin, Evelyn, Katja, Mara, Adam, Kirian, Marcel, Paul, Raffael, Simon

---

## Übersicht:

Angesetzt war es für 1200  und sollte bis etwa 1330 laufen.
Es wurde bis 1205 auf Paul gewartet, welcher anschließend ebenfalls beitrat. 

Bis zu diesem Meeting wurden diverse Deadlines gesetzt, die dazu gedient haben einen Grundsatz für die Arbeit mit Godot aufweisen zu können. 
Ferner sollte hier ein erstes System zum _erstellen_ einer interaktiven Grid-Struktur gebaut werden, sodass die Teilnehmenden erste Erfahrung mit der Arbeit und Struktur von Godot machen konnten. 

Dieses Meeting dient weiterhin dazu neben der abgeschlossenen Konzeptualisierung des Spieles auch eine erste Implementation angehen und für das Meeting im Dezember vorzeigen zu können. 
Weiterhin wurden folgende Themen angesprochen und bearbeitet:

### Ablauf:
1. _Besprechen der Vorarbeit_ 
   Besprechen von Problemen, ersten Implementationen und Ansätzen. Auftretende Fehler oder Komplikationen lösen.
	1. Anmerkungen bei der Implementation
2. Aufteilung / Neustrukturierung des Teams
3. Setzung von Teams, die im ersten Sprint gemeinsam arbeiten.
4. Festsetzen und besprechen der Ziele für den jetzigen Sprint
5. Festlegen von Zielen, verbunden mit Deadlines
	1. Struktur der Meetings
6. Beispiel Level ( aus Ausarbeitung des _Game-Design Teams_) besprechen
7. Setzung des High Court Meeting

## | 1. Implementierung | Experimentieren
Es wurde zuerst evaluiert, wer sich mit Godot auseinandersetzen und etwas kleines - primär um sich mit dem System vertraut zu machen - bauen konnte.
Folgend eine Auflistung dieser kleinen Übungen:
- Simon hat sich an einem Kamera-System versucht, weiterhin auch schon eine erste Tilemap gebaut 
- Mara hat sich ein Drag'n'Drop System angeschaut und umgesetzt. Weiterhin auch ein Tutorial zum erstellen eines Sidescrollers 
- Evelyn hat sich in die Struktur, Interaktion der Nodes etc, eingearbeitet, einfach schauen, wie GODOT läuft / funktioniert. Dafür versucht ein Drag and Drop System zu implementieren

### Vorstellung dieser:
**Mara** hat their System kurz vorgestellt:
Godot stellt ein Internes Framework bereit, was eine Interaktion mit _drag and drop_ ermöglicht. Dabei wurde also besagtes System angewandt und darauf aufgebaut.
They haben hierbei eine **interne Gridmap**, sowie **TextureButtons** verwendet, um Interaktionen mit den _draggable objects_ zu ermöglichen.
Dabei haben die _TextureButtons_ eine Gruppe "draggable" erhalten, um tracken zu können, ob sie verschoben werden können oder nicht 

Implementationsdetails können im Repo entsprechend eingesehen werden, **link folgt**.

Es wurden anschließend mögliche Probleme der Implementation betrachtet und besprochen:
-> Während das Beispiel hier ein Drag'n'Drop mit Objekten, die nur ein Feld füllen, gut funktioniert, wird es schwieriger sein Objekte verschiedener Größe entsprechend einfügen zu können. Dafür müsse man eine sinnige Lösung finden, damit keine Überschneidungen auftreten können.

Es wurden anschließend einige Möglichkeiten angesprochen, sodass Ansätze zur Lösung gegeben werden können.

Es besteht die Möglichkeit diese Überlagerungen im Grid-System über die Verwendung von **Collision-Boxes** zu realisieren. Dabei könne man die internen Parameter von Godot anwenden,um so eine Collision zu verhindern. Für diesen Lösungsansatz treten jedoch einige Probleme oder Fragen auf:
- erstellen der Collision-boxes passend zur Form 
- Wie kann die Überlagerung geprüft werden?
- Wie können entsprechende Effekte von Objekten (Tieren) neben der Collision-Boxen noch eingefügt werden?

Die genaue Umsetzung dieses Ansatzes wird im weiteren Verlauf des Sprints ausgiebig getestet, um eine entsprechende Lösung dafür zu finden.


>[!Important] Anmerkung Evelyn
>Vielleicht sollten wir in unserem **REPO** einen extra **Ordner anlegen**, der dafür genutzt werden kann, dass man die Beispiele / Experimente später nochmal anschauen kann. 
>dafür würde ich im Root folgend noch einen Ordner "testing_area" vorschlagen
>```bash
>.
>└── testing_area
>    └── godot_examples
>        ├── evelyn_randomWorldGenerator
>        └── name_whatitdoes
>```

---
## | 2. Teamaufteilung:
Es wurde der Ansatz vorgetragen, dass für den ersten Sprint zwei große Gruppen gebildet werden, welche anschließend für den Rest dessen an der Implementierung der Brücken arbeiten. Das heißt also, dass wir zwei Teams aufsetzen, die das gleiche Feature implementieren, um so unterschiedliche Ansätze aufweisen und später diskutieren zu können. Weiterhin bietet dies den Vorteil, dass bei dem Meeting ein Feedback für die ersten Prototypen erhalten werden kann und so eventuell eine Lösung als sinnvoller erkannt wird.

Dieser Vorschlag wurde anschließend diskutiert:

Adam äußerte sich dieser Idee kritisch:
-> zwei Teams aufzusetzen, die dann jeweils 5 Personen an der gleichen Funktion arbeiten lässt, erscheint eher als ineffizient, da am Ende garantiert eine der beiden Ausarbeitungen verworfen wird. 
Weiterhin merkte er an, dass Probleme, die dem einen Team während der Entwicklung auftreten werden, später wohl auch dem Anderen Zeit kosten werden. Daher scheint es sinniger bei einer Aufteilung in Gruppen lieber zwei verschiedene Features bearbeiten zu lassen.

Dieser Kritik wurde entegegnet, dass durch die Aufteilung in zwei größere Gruppen eine höhere Redundanz der Arbeitenden vorliegt, gerade unter Betrachtung des Aspektes, dass alle Studierende sind.

**Pair programming** kann bei der Ausarbeitung in der Gruppe helfen, da man so gemeinsam Ansätze, Probleme und Ideen wahrnimmt und löst.

es wurde eine weitere Kritik bezüglich des Vorschlages geäußert:
- Es muss nur einen Prototyp zum nächsten Meeting geben, und keine zwei. Dadurch kann man sich die doppelte Arbeit des gleichen Themas schenken und lieber ein weiteres Feature einbringen.
- Dieser Punkt ist gerade relevant, weil wir viele Features implementieren wollen und so die Zeit wichtig und beschränkt ist

Es wurde angemerkt, dass das Brücken-Bau-System in seiner Grundlage ( Backend) relativ ausgiebig konstruiert werden muss. 
Selbiges Grundkonzept sollte so auch für das Kartensystem und dem verbundenen Combat nutzbar sein, also sehr viel Zeit dafür benötigt wird.
Dabei ist wichtig, dass man sich nicht im **Karten-System** und dessen Komplexität verliert, aber dennoch genügend Zeit dafür allokiert, damit es sinnig implementiert werden kann.


>[!Info] Paul, Adam und Evelyn äußerten sich gegen den Vorschlag, dass zwei Gruppen an der gleichen Sache arbeiten. 
>Auch die anderen Teilnehmenden stimmten der Kritik und der Neuiteration der notwendigen Struktur zu.


Es wurde anschließend folgender Vorschlag gebracht:
>[!Definition] Vorschlag: 
>Es werden zwei Teams aufgesetzt, jedoch wird sich eines mit **dem Kartenspiel** auseinandersetzen und das andere **das Bridge-Building**
>
>Durch diesen Ansatz haben wir bei dem ersten Meeting zwei Prototypen vorzuzeigen, die grundlegend funktionieren sollten.


>[!Warning] Anmerkung Mara zum Kartenspiel:
>Das Balancing im Kartenspiel sollte nicht der größte Fokus werden, da hier sehr viel Aufwand betrieben werden muss, um eine entsprechende Komplexität zu erzeugen und verwalten.

Es wurde anschließend noch ein Vorschlag von Paul gebracht:
>[!Definition] Pauls Vorschlag:
>Statt des **Kartenspiel** und **Bridge-Building** sollten wohl erstmal das **Brückenspiel** und die Overworld implementiert werden.
>
>Das hat den Vorteil, dass dadurch nicht die beiden komplexesten Bereiche, also das Kartenspiel und Bridge-Building gleichzeitig bearbeitet werden müssen.
>Weiterhin ergibt sich so die Möglichkeit beide Teile des Spieles bereits zu verknüpfen, um so einen Prototype vorzeigen zu können, der zwei von drei Core-Mechanics bereits verknüpft hat.
>
>Dadurch erscheint es auch weniger so, als würden zwei eigenständige Spiele entwickelt werden.

Diese Idee wurde größtenteils gut angenommen und weiter besprochen:

>[!Tip] Vorschlag von Aylin:
>Die Aufteilung der Gruppen sollte etwas anders sein: 
>- eine kleinere Gruppe arbeitet an der Overworld
>- eine größere Gruppe am Bridge-Building game


Es wurde somit ein Konsens gebildet, der den weiteren Verlauf für den Sprint setzte:
1. Es findet eine Aufteilung in zwei Teams statt
	1. das kleinere Team baut die Overworld
	2. das Größere das Bridge-Building Spiel
2. Jedes Team hat eine Verantwortliche Person, die die Arbeit koordiniert und beim High-Court Treffen anwesend sein wird.
3. Es wird **mindestens 1 Meeting pro Gruppe** durchgeführt
4. Innerhalb der Teams werden **Deadlines** etabliert, damit kleine Ziele erreicht werden. 

Anschließend haben sich die beiden Gruppen gebildet:
**Overworld**: 
- Paul, Evelyn, Simon
**Bridge-Building**:
- Mara, Adam, Aylin, Raffael, Katja, Kirian, Marcel

**Anforderungen** für diese Prototypen:
- sie müssen grundlegend funktionieren
- brauchen keine sehr schöne Struktur 
- Code sollte ok-ish sein, darf aber code-smells aufweisen / nicht optimiert sein
- wichtig ist, dass man die **technical debt** dokumentiert, sodass sie später **gelöst werden kann**.
- **Ziele** definieren, was / wie gemacht werden muss, bis zu einem bestimmten Zeitpunkt

### Beispiel-Level | Game-Design
Es wurde vom Game-Design Team ein erstes Beispiel-Level auf Github geteilt und in einem PR verankert. [hier zu finden](https://github.com/mango-gremlin/arch-enemies/pull/22) 

Dieses Level ist sehr ausführlich beschrieben und weist viele Details ( Skizzen, Anmerkungen etc.) auf. 

>[!Important] Maras Bemerkung
>They hat angemerkt, dass dieses Beispiel vorerst das **Ziel des Projektes** darstellen solle, weil es sehr ausführlich ist [ und viel funktionierende Grundstruktur voraussetze, die erst geschaffen werden muss ].
>
>Dieses Beispiellevel **wird am [Date:2023-11-19] abends ins Wiki übernommen**, sofern bis dahin keine Anpassungen / Probleme vermerkt oder vorgenommen werden.

---


## | Meetings |

**Das wöchentliche Meeting** der Verantwortlichen der Gruppen wird wieder **am Donnerstag 1030** stattfinden.
Hierbei können alle Mitglieder teilnehmen, um so eventuell Anliegen kommunizieren zu können.

**Die Gruppen** sollen sich ebenfalls mindestens einmal wöchentlich treffen, um den aktuellen Stand, Probleme und weiteres kommunizieren zu können.

**Das nächste große Meeting** wird am Sonntag, dem [Date:2023-11-26] stattfinden.

## Anmerkung Mara:

> Mara hat viel in den General-Chat im Discord geschickt / gepingt.
Dabei der Appell:

>[!Error] auf **Github schauen**
>Es wäre von Vorteil frequent mal im Github den ZUstand zu erhalten und tracken, da so evaluiert werden kann, wie der Zustand ist etc.
>
>Es ist insofern wichtig, da wir so Inhalte von den Personen 


---

# preliminary notes | discussion

Below you may find the notes written by Mara. They used them to have a rough schedule at hand for the meeting held. 
#### Godot Vorarbeit
1. godot angeschaut?
2. Wie implementieren
	1. drag and drop implementierung
	2. hitboxen -> tilemaps, aber: kann man tilemaps drag and droppen?
	3. grid system -> siehe drag and drop
	4. puzzle vollendung
3. sachen die noch aufgefallen sind die wir noch brauchen
	1. grid system, aber tiere die mehrere grid punkte aufnehmen wie?
	2. wie bewegt man die daten hin und her
	3. wie transformiert man die dahin gedraggten tiere zu platformen mit hitboxen? 
		1. -> instantiate new tilemaps when bridge placed and locked in?
	4. platforming: das ist einfach zu implementieren -> siehe beispiel template

### Teams, wie implementieren
-> da es jetzt doch nicht so kompliziert war, könnte man versuchen, in den 2 teams jeweils einen prototyp für combat und einen für bridges zu entwickeln, statt dass alle an bridges arbeiten
- mögliche gefaahr, dass es doch nicht so einfach wird, und wir am ende ganz ohne prototyp dastehen
- aber vorteil, dass wir dann schon mehr geschafft haben & wir haben weniger redundanz, weil dann jeder was sinnvolles machen kan
- thoughts?

### Ziele für nächste Woche:
- was wollen wir bis mitte der woche geschafft haben
- was bis ende der woche
- wie oft meetings in untergruppen

#### Example level
- wird ins wiki übertragen (einf die docs?) -> endziel für unser projekt, aber erstmal nicht wichtig für diesen sprint

---

### Notizen des letzten Treffens:

>[!Important] alle können da kommen und mitreden, die teamleaders müssen nur. Aber wer sonst zeit hat kann auch gerne vorbei kommen.

Notes von der Vor-Planung:
Half Week: 16.-19.11.
Godot anschauen, einlesen
Bridge Framework
godot beispiel laufen lassen, entwicklungsumgebung läuft
szenen verstehen
nodes anlegen
als was könnte man draggable Objects/Tiere implementieren
wie kann man hitboxen implementieren
grid system zum snappen von tieren
wie checken, dass puzzle vollendet ist (flooding)

### Ziele für Sonntag
alle programmieren mit, auch game design → innerhalb dessen Teams für die erstellung dieses Prototyps
Roadmap für was wir wann machen wollen
fragen zu godot klären
mehr dinge in wiki schreiben
→ am ende der woche, nochmal vergleichen, schauen was besser funktioniert, was wir nehmen
für jede Gruppe 1 verantwortlichen, der progress updates an die anderen gibt
man trifft sich dann in diesen Gruppen während der woche, so oft wie nötig
2 Gruppen, die beide mal das ganze 