# High Court - Meeting | 2023-12-07
anchored to [[125.07_meeting_20231207]]

---

## | Overview |

Wie in den vorherigen Wochen wurde ein Treffen der Repräsentierenden der einzelnen Gruppen und Glen ( als Leitung )  vorgesehen und umgesetzt. 
Dabei wurde das Feedback des letzten Meetings mit den Verantwortlichen besprochen und verarbeitet, weiterhin die neuen Ziele für den nächsten Zeitraum gesetzt und besprochen.

## | Updates | 

>[!Important] aktuelle GODOT Version
>Wir updaten auf Godot 4.2, da es uns in der Arbeit eventuell vorherige Fehler beheben und die Arbeit damit vereinfachen kann. 
>Wetierhin wurden einige Änderungen / Verbesserungen für die Arbeit mit Tilemaps eingeführt, welche uns bei der Gestaltung der Overworld helfen können. 

Es wurden anschließend die Zustände der einzelnen Teams besprochen ( Overworld, Bridges ) und anschließend über den weiteren Verlauf und die angepeilten Ziele diskutiert.
## | Ziele für nächsten Sprint | 

Wir müssen am **09.01.2024** wieder Updates vorzeigen können, daher sollten Ziele und Prioritäten für Aufgabengebiete baldig definiert und bearbeitet werden. 

Dabei ist es wichtig in den zwei Wochen vor den Weihnachtsferien ( W49, W50, W51 ) bereits an den nächsten Zielen zu arbeiten, sodass über die Ferien keine notwendige Pflicht besteht, daran weiter zu arbeiten. 
Natürlich ist es freigestellt unter Umständen auch während dieser Zeit zu Arbeiten, es sollte aber nicht erzwungen / vorausgesetzt werden.

Folgend eine Listung der Ziele, die die Gruppen bis zum Abschluss des nächsten Sprints bearbeiten und lösen sollten.
### | Overworld | 

**| Ziele |**

- Code verbessern ( Struktur und Aufteilung aktualisieren) 
- Tilemap  
	- neue / eigene Assets 
	- Autotiling für einfacheres World-Design 
- Interaction verbessern ( Item / NPC)
- Dialog-Optionen einbauen / ermöglichen.
- collision bei ungebauten Brücken  --> also etwa einen Übergang zur anderen Insel einbauen //
- Repräsentation von leveln 
- schöne Overworld --> beispiele, abhängig von Tilemap struktur 
	- Beispiel-Insel mit Interactionen 
	- vielleicht noch einen Ansatz für eine Brücke 
	- (optional) (particle effects wären so cool! --> Wolken beim rauszoomen xd)
- convert player to **Singleton** 
	- simplify saving items 
	- simplifies access to player object and its values ( inventory in different scenes etc.)
- **player**
- UI 
	- Conceptualize necessary items 
	- conceptualize 
- **Overworld** Motivation / Incentives (_gamedesign_)
	- Motivation, um Items zu sammeln? 
	- **Motivation**, um Tiere zu sammeln?

### | Bridges | 

**| Ziele |**:

- Code refactoren / aufsplitten 
	- sollte reusable sein 
- Bug fixes bearbeiten und lösen
- collisions der Tiere verbessern 
- rotation von Tieren 
- vielleicht Template, um weitere Hazards einfach einfügen zu können
- Menge von Tieren, die vorhanden sind, abhängig vom Inventar (**Overworld**)

### | Game Design | 

Sollte sich treffen, um die Konzeption des Spieles, jetzt ohne Combat, nochmal anzupassen und zu aktualisieren. 
Dabei gibt es im Bereich der Overworld, sowie dem Brdige-Building noch Unklarheiten bzw Fragen, wie bestimmte Themen beearbeitet, Konzepte umgesetzt werden sollten.

Einige sind folgend gelistet:
- NPCs and dialog
- what assets and necessary ui elements?
- what does overworld look like?
- how do you get items / allies?
- bridge hazards?
- story: course of events
- Motivation für Overworld-Konzeption

Diverse Punkte müssen bearbeitet und anschließend den Teams, die es betrifft, kommuniziert werden.
Da in jeder Gruppe mindestens eine Person enthalten ist, sollte diese Kommunikation gut möglich / umsetzbar sein.

### | UI | 

UI wird sich demnächst um Sprites kümmern. Folgend Bereiche werden sie abdecken:
- Overworld UI 
	- bzw erste Konzepte für die Gestaltung dieser
- Aktualisierung der Sprites im Bridge-Bereich
- Einbringen von Assets für die Overworld 
	- Größe der Tilemap-Blöcke

Weiterhin wird die "List-Of-Assets" aktualisiert und in zwei (Overworld, Bridge) aufgeteilt, sodass die Teams in diesen Requests setzen / anmerken können.

---
## | Ziele | Aufgaben |

Wie in den vorherigen Iterationen bereits umgesetzt, sollten sich die einzelnen Gruppen im Zeitraum bis zum nächsten High-Court Meeting treffen, um die Aufgaben aufzuteilen, zu kommunizieren und an dem Projekt weiter zu arbeiten.

Da hier jetzt große Änderungen im Grundkonzept des Spieles vorgenommen wurden - Combat entfällt als Komponente - ist es notwendig, dass sich die **Gamedesign**-Gruppe möglichst baldig trifft, um diese Themen zu bearbeiten und an die anderen Teams weiterzugeben.

Optimalerweise sollten sie sich dann **vor den anderen Gruppen** treffen, damit diese die Informationen rechtzeitig in ihrem Meeting aufbauen / einbringen können.

Weiterhin sollten sich auch **Overworld** und **Bridge** treffen.
Dabei sollte folgendes bearbeitet werden: 

>[!Task] Ziele bis zum nächsten High Court
>Es sollten bis zu nächstem Meeting folgende Schritte bearbeitet und begonnen werden: 
>- Issue erstellen
>- Issues **zuteilen** 
>- (intern) erste Deadlines setzen
>- Beginnen an den Problemem zu arbeiten 


