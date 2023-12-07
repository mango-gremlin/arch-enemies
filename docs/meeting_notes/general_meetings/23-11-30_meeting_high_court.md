# Treffen 2023-11-30
anchored to [[125.00_anchor]]

---

## Überblick aktueller Status: 

### Team | Overworld
Wird sich am Freitag treffen um die letzten Features zu implementieren: 
- autotiles ( optional )
- Overworld testweise bisschen schöner gestalten @paul ?
- State saving ( also Position in der Overworld etcetc )
- Die Interactions nicht mehr **mit Strings abgleichen**, sondern enums oder ähnliches ?
- NPC einfügen ? ( optional ) ( einfach nur schauen, wie man vielleicht ne Dialog-Box aufbaut und einbringt )
- Dialogbox einbringen, die bei "NPC" Encounter auftreten / genutzt werden kann

---


### Team | Bridges
Es wurden _delta_  zu Sonntag diverse Features implementiert und Issue erstellt und gelöst.
Der genaue Verlauf kann dem Repository entnommen werden.

**Weiterhin**: 
Bestehen noch einige Issues, die bearbeitet und gelöst werden müssenn. 

>[!Important] Marcels Overhaul
>Marcel hat ein neues System eingebracht, was die Mechanik ( siehe PR #75 ) nochmal neu konstruiert und somit mehr oder weniger eine bessere Implementation des Dragging-Systems erlaubt / ermöglicht. 

Durch diese Struktur sind einige Issues trivial geworden, da sie durch das neue System nicht mehr auftreten würden. 

>[!Task] PR von Kirian (# 79)
>Dieser ist noch nicht fertig und weiterhin **derzeit out-of-date** mit dem aktuellen main-branch. 
>Dadurch ist es notwendig, dass dieser Zustand in den Branch übernommen und somit anschließend aktualisiert wird, bevor es gemerged und somit abgeschlossen werden kann.


**Es wurden folgende Features gemerged:** 
1. #75 (overhaul des Dragging-Systems)
2. #78 (check der Platzierung der Tiere und Fundamentales Framework zum einbringen von Spinnen und weiteren Tieren)
3. #74 (roundToNearest moved to global) wurde mit einigen Merge-Conflicts resolved 


>[!Warning] Bugs, Deadline bis zum [Date:2023-12-03]
>Es sind weiterhin drei Issues offen, die bis Sonntag bearbeitet werden müssen.
>
>Sie sind grundlegend für unsere Struktur, und sollten deswegen bis zum Vorstellen des  Prototypes 
>
>Liste dieser: 
>1. #77 -> (squirrel snaps to wrong grid) 
>2. #76 -> (Snapping allows placement of invalid positions)
>3. #80 --> fixed problem that occurred after merging the two previous PRs

---
## Aufgabenverteilung bis [Date:2023-12-01]:
Folgend haben wir diverse Aufgaben, die bis zum Abschluss ( und ersten Merge der Implementationen) des ersten Sprints abgearbeitet bzw. fertig gestellt werden sollten.

- Kirian sollte sein Issue beenden, (#79)
- Marcel wird eine erste Implementation einer Spinne einbringen können
- Raffael, Glen, Katja (#76)
- Aylin, Marcel (#77)
- Adam macht das Grid (#62) 
- Glen, wird sich der "Lösbarkeit des Beispielrätsels" widmen (#82)
- (optional) (#33, feature ) kann noch verteilt werden.

Besprechung oder Evaluierung von Ausarbeitungen:

1. Kirian: 
Hat bei seiner Implementation einen sehr alten Branch von main genutzt, weswegen sein Fix / seine Änderungen nicht entsprechend übereinstimmen. 

2. Adam:
Ist zeitlich verhindert, sollte jedoch an einer kleinen Aufgabe arbeiten. 

---
## Präsentation:

Es war / ist unsicher, wie genau dieses Meeting ablaufen kann / wir und was präsentiert und vorgestellt werden soll. 

Es sollte eine Mail geschrieben werden, um folgende Inhalte in Erfahrung zu bringen:
1. Wie viel vorgestellt werden muss
2. Wie viel Zeit wir haben
3. Wo das Meeting ist ( weil viele Personen anwesend sein müssen)
4. Was ist mit "prototype primary gameplay loop"

>[!Task] **Glen** hat folgend eine Mail formuliert, die diese Informationen erfragt hat. 

Aus den Slides wird formuliert:
- dass der "primary Gameplayloop" vorgestellt werden muss
- und der Status des Spiels

### Ausarbeitung der **Präsentation**: 
Da noch keine genauen Informationen gegeben sind, wird die Präsentation bzw die Ausarbeitung dieser erst dann erfolgen können, wenn die Mail beantwortet wurde. 
Dabei wird eine Deadline bis zum [Date:2023-12-03] gesetzt.


#### **Nachtrag** [Date:2023-11-30] um 12:00:

Es wurde auf die Mail geantwortet, wodurch die Informationen erhalten wurden, die notwendig sind, um die Präsentation vorstellen zu können.

>[!Quote] Antwort:
>Hey, the meeting is going to be in the same format as the last. Individual group meetings at the TTR2 second floor seminar room. Showing and explaining the prototype is the main thing, you can do it as a live demo or show some pre-recorded videos. If you have other things to show you can also add slides.


---
## REPO Maintenance

### Branches löschen
Wir haben von **29** Branches 26 gelöscht.
Diese gehörten zu diversen Features/ Bugs etc. 

### Issues archivieren:
Es wurden diverse Issues aus dem aktuellen KanBan archiviert.


---
# Anmerkungen: 
>[!Important] Besprechung der Anmerkungen
>Folgende Anmerkungen, Ideen sollten im nächsten gemeinsamen Meeting angesprochen und **beschlossen werden**, damit wir diese Konventionen, unter Umständen / bei Bedarf, auch entsprechend einbringen können. 

### Mögliche Konvention für **Pull-Requests**:
Es ist wichtig, dass bei Pull-Requests immer ein Status angegeben und **dieser auch aktualisiert** wird.
Das heißt, dass hier die Flags / Label "ready for review" etc. aktiv genutzt werden sollten, da sie dazu beitragen **eine gute Übersicht**  des Status zu erhalten. 

### Mögliche Konvention bei **Issues**:
Auch hier sollten immer die Label gesetzt und auch der **Status** im Project eingetragen werden, **denn auch hier ist es wichtig**, dass man den aktuellen Status **leicht einsehen kann**.

Somit folgt: 
1. **Beim erstellen**: Setzt man das Issue auf "TODO"
2. **Bei Beginn der Bearbeitung**: Setzt man das Issue auf "In Progress"
3. **Bei Abschluss / wenn der PR erstellt wurde**: Setzt sich das Issue automatisch auf done, wenn der **PR geschlossen wurde**. 
