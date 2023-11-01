# Meeting notes: 
anchored to [[113.00_anchor]]

---

## Overview:
Im Laufe des Semester sollten wir uns in möglichst frequenten Treffen zusammensetzen und den Stand des Projektes, Anliegen, Probleme oder Updates besprechen. 
Folglich findet sich hier eine Auflistung der Notizen, die zu jedem Treffen getätigt wurden.


## Treffen | 2023-11-01: [[Date:2023-11-01]]
Primär ging es heute um die Grundlagen für unser Projekt. Dies schließt ein, die Gruppen zur Bearbeitung von diversen Teilgebieten unseres Projektes zu setzen oder genauer über Entscheidungen und Ideen für das Spiel zu reden, um so ein Bild zu schaffen, was wir in den fortlaufenden Treffen bearbeiten und formen könnnen.


### Gruppenfindung:
Zur sinnvollen Bearbeitung diverser Teilgebiete,  sollten wir uns in kleinere Gruppen aufteilen, die diverse Themengebiete spezifisch anvisieren und bearbeiten. 
Prinzipiell bezieht vieles die Programmierung mit ein, doch haben wir uns schon vor dem Meeting drei grobe Gruppen aufgesetzt, die wir womöglich in kleineren Kreisen arbeiten lassen sollten:
- Grafik | Ui, assets und mehr
- Game Design | Konzeption, Balancing und Grundlage zur Entwicklung
- Backend | Fokus auf Programmierung mit Game-Engine, Umsetzung von Spiel-Ideen und mehr
Diese Gruppen wurden im Meeting nochmal angesprochen und bei ihrer derzeitigen Einteilung belassen.
Es wurde angemerkt, dass es notwendig sein wird, dass **alle Gruppen gut miteinander kommunizieren** und in verschiedenen Staten der Entwicklung womöglich **wachsen oder schrumpfen können**.
Spezifisch wurde es darauf bezogen, dass diverse Teilnehmende in Bereichen der Grafik oder Game-Design im Laufe des Prozesses auch im Backend aktiv sein werden / können / würden.

>[!Warning] Backend ist sehr grob gefasst
>Am Ende wird mit der Gameeengine Godot gearbeitet und alle Einheiten ( Design, Logik, Code) in dieser zusammengefasst.
>Dadurch sind wohl alle am Prozess darin eingebunden. 

>[!Tip] Zu Beginn hohe Kommunikation zwischen Game-Design und Backend:
>Denn es ist notwendig abzuschätzen, **was machbar ist** und **was in der Engine, dem Environment** umgesetzt und bearbeitet werden kann.
>
>Es bietet sich also an, dass diese beiden Gruppen _Backend_ und _Game-Design_ zu Beginn in **hoher Kommunikation** stehen.

### Koordination:

#### Progress Tracking:
**Zum Tracken von Progress** werden wir uns eines **Kanban-Systems** annehmen.
Dabei steht soeben zur Debatte, ob wir das interne Tool von **Github** nutzen sollten / werden oder uns auf die Open-Source-Lösung **Taiga** fokussieren. 
**Mara** wird sich beide anschauen und ein Update dazu teilen.

Weiterhin ist es angedacht, dass sich die **Teams möglichst wöchentlich** in kleinen Gruppen **treffen können**.
Dadurch soll eine hohe Kommunikation zur Bewältigung von Problemen, Fragen und Ansätzen ermöglicht werden, weiter dient es aber auch dazu, Updates an die weiteren Gruppen propagieren zu können.
**Die Findung von Terminen** wird dabei den Teams selbst überlassen.


**Versions-Kontrolle _und_ Code-Sharing** wird bei uns mit einem Github-Repo bewerkstelligt. Dafür hat **Mara** ein Repository eröffnet und alle Beteiligten eingeladen und als Collaborators eingerichtet. 
Link: https://github.com/mango-gremlin/arch-enemies

### Gameengine | GODOT:
Wir möchten die neuste Version (4.xx) von Godot anwenden und auf dieser aufbauen, weil wir damit die **aktuellste Dokumentation**  konsultieren können und mit den neusten Features arbeiten können ( sofern sie für unsere Arbeit sinnig erscheinen). Dadurch ist es uns nicht möglich das Spiel auch im Browser laufen zu lassen, da dies auch nicht zwingend gefordert wird, sollte es jedoch kein Problem darstellen.

>[!Info] Genutzte Programmiersprache
>Die genutzte Programmiersprache wird **C#** sein. 
>Es wird hierbei wahrscheinlich auch einiges kleines in Form von godot-script geschrieben, aber primär soll der Foksu auf C# liegen.
>


#### Übung und Vorbereitung:
>[!Task] Grundlegende Arbeit | Benutzung von GODOT lernen
>Da, wie oben erwähnt, alle GODOT nutzen müssen und so ein Grundverständnis für das Programm und seine Möglichkeiten benötigen wird, ist es angedacht **dass sich jede Person** bis zum nächsten großen Treffen **Grundlagen zur Nutzung und Arbeit mit GODOT** anschauen sollte.
>
>Hilfreiche Resourcen:
>(tbh gibt es fucking viel lol), to name a few:
>- https://www.youtube.com/watch?v=1_OFJLyqlXI
>- https://www.youtube.com/watch?v=mAbG8Oi-SvQ
>- https://docs.godotengine.org/en/stable/about/introduction.html


>[!Example] Aufgabe _Personen im **Backend**_
> Diese sollten bis zum nächsten Treffen schonmal versuchen **eine einfache Overworld** zu basteln, die es ermöglicht als Character über eine Welt zu laufen. 
> Dabei sind keine speziellen Features notwendig, es geht darum **sich mit den Grundlagen vertraut zu machen**.

### Spielidee/Konzept | Vertiefung und Besprechung:
- Es solle sich um ein **free movement game** handeln. 
	- "open world aber auf den lokalen Inseln begrenzt ( Interaktionen mit Umgebung) möglich"
- auf einer Insel muss man bestimmte Objektives erfüllen **um Tiere zu sammeln** bzw. anzuwerben. Das könnten folgende Objektives sein:
	- **Ressourcen sammeln** damit sie mitkommen oder überzeugt werden.
	- gegnerische Lager, die den Zugang zu Resourcen verweigern und so bekämpft werden müssen
	- **Ressourcen** bedingen manche Tiere --> etwa Schlange um in den Baum zu kommen, wo sich eine spezifische Resource findet 
- Es sind die einzelnen Fraktionen auf der Welt verteilt abrufbar / einsehbar

### Combat:
- Im Spiel sollte man nicht nur kämpfem können
	- sondern auch überzeugen ( ähnlich zu undertale) 
- Es gibt als primäre Aktion **Karten**, die angeben, was ausgeführt werden kann
	- $n$-viele Karten verfügbar pro Runde. 
	- Karten werden einmalig genutzt und dann auf einen _Ablagestapel_ versetzt
	- Ist dieser Ablagestapel voll, dann wird gemischt und die Karten wieder neu ausgelegt

#### Fokus: Karten:
Durch diverse Spezies bilden sich verschiedene Effekte
- manche Spezies tragen bestimmte Karten oder Effekt bei, die dann gegen andere Spezies einen Vorteil / Nachteil bedeuten können
- Es könnten hierbei auch **Synergien** erzeugt werden, die einen Bonus schaffen könnten

Alternativ zu dem Karten-System, bei welchem Attacken durch diese bestimmt werden, könnte man auch einfach ein spezielles Kartenspiel ( system ) einbringen und überarbeiten.
Ein **Beispiel wäre _Poker_**:
- Pokern gegen den Gegner 
- aber die Karten sind in **Tier-Themes**

**Durch die Nutzung** eines bestehenden Systems wird die **Implementierung** und das _Balancing_ wahrscheinlich einfacher und wir könnten uns weniger darauf fokussieren.

>[!Warning]
> Spezifische Ausarbeitung gebührt **Game-Design**-Gruppe und wird von ihr ausgearbeitet und präsentiert


**Synergie**:
- Zusammenarbeit zwischen Tieren bieten Vorteile: 

Zwischen **Combat und Brückenbau** sollte eine Abhängigkeit auftreten, sodass man entsprechend entscheiden muss, wie die verfügbaren Resourcen genutzt werden.
- erzeugen eines **Dilemma**: Ressourcen bedingen zum einen den Brückenbau und auch den Kampf
	- weise entscheiden! 
- diese Mechanik vermittelt einen Reward, wenn man Brücken gut baut oder Kämpfe sinnvoll setzt. (und somit entsprechend für die andere Komponente mehr Ressourcen hat)

### Protagonist\*in:
- man könnte hier zwischen einer von 3 Fraktionen auswählen ( default 1)
- Protagonist\*in repräsentiert dann die Gruppe der Fraktion
	- gibt orders 
	- läuft über die Brücken 
	- spricht mit NPCs ...

### Antagonist\*innen:
- Antagonist\*innen sind primär **die Haustiere** gegen die wir kämpfen
Als Idee wurde hierbei folgender Charakter gegeben:
- _Gans anonym_ als vermeintlich helfende Instanz, die dazu beitragen möchte zu helfen 
	- nicht ganz Troubled waters 

**Eine weitere Idee**: 
Es war eine Flute, die dazu beitrug, dass der Wald von einem trockenen Gebiet über zu einem sumpfigen Wald konvertierte und damit **neue Spezies** in den Lebensraum eindringen werden. 
Dabei ist dann die Antagonisten-Rolle auf die _invasiven Tiere_ gemünzt, welche aus **ihrer Sicht nur überleben möchten**.
- Haupt-Antagonist\*in: **toadally anonymous** ( Frosch )
	- eventuell wurde die Flut von ihnen verursacht
	- toad auch als **invasive Spezies**, die den Wald bedroht ( begründet den Namen, weil man sie zuvor noch nicht gesehen hat?)
- Die **Motivation**, die dabei beide Seiten bestrebt gegeneinander zu agieren: 
	- (Waldtiere): Gefahr, der Wald wurde geflutet und wir müssen zusammenarbeiten
	- (invasive Spezies): man möchte in neuem Umfeld überleben.

- Da beide Seiten eher gebrochene Ziele haben, lässt sich **begründen**, warum man die Spezies im Kampf auch überzeugen kann.

Als möglicher Plot-point:
toadlyy anonymous möchte die alten Tiere miteinander verbünden, und sie dazu drängen **gemeinsam** gegen die invasive Spezies zu kämpfen. 
Der Plan ist dabei, dass so alle Waldtiere gesammelt werden und dann von der invasive Species an einem speziellen Punkt durch eine **geplante Überflutung** (etwa damm gebaut und dann überfluten sie ein Tal o.ä.) umgebracht werden könnten.


### Side-Notes: Charakter-Ideen:
- Libellen mit AUgenklappen
- Piratten

### Nächtes Meeting | 
Zum nächsten Meeting müssen Grundlagen und erste Ideen und Konzepte gesammelt und für die Vorstellung bei den Dozent\*innen aufbereitet werden.
Dabei treffen sich jeweils **Repräsentierende** der einzelnen Gruppen, um zusammen zutragen.

>[!Important] Datum Meeting
>Das Meeting zum Zusammentreffen der einzelnen Repräsentierenden der Gruppen ist für folgendes Datum angesetzt:
>**2023-11-9** _1000_ Uhr. 
>Location: **noch unbekannt**