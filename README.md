# Unofficial RoE Communitypatch
Dieser inoffizielle Patch behebt diverse Bugs der History Edition vom Spiel 'Die Siedler - Aufstieg eines Königreichs' und fügt neue Features hinzu.



## Installation
Mit folgenden Schritten lässt sich der Patch installieren:
1. Sicherungskopie vom AeK-Ordner anlegen und z.B. "thesettlers6_Orig" nennen
2. Projekt über Code -> Download ZIP herunterladen
3. Projektordner in den Ornder OHNE "_Orig-Zusatz" entpacken und die Frage nach Überschreiben von X Dateien bestätigen
3. Zocken



## Features
Folgende Änderungen wurden vorgenommen:
- Ritter
	- "Alte" Ritter überarbeitet
		- Allandra
			- Passive Fähigkeiten: Bonusgold für Predigten erhöht (20% -> 40%)
			- Bonus: Lebenspunkte leicht erhöht (1.000 -> 1.100)
		- Elias
			- Aktive Fähigkeit: Gewährt zusätzlich den "Vielfältige Nahrung"-Bonus
			- Passive Fähigkeiten: Handelsbonus erhöht (20% -> 40%)
		- Hakim
			- Aktive Fähigkeit (Konversion)
				- Cooldown leicht erhöht (7:30 Min. -> 8:00 Min.)
				- Kann nicht benutzt werden, wenn Soldatenlimit schon erreicht
		- Marcus
			- Bonus: Lebenspunkte leicht erhöht (1.000 -> 1.100)
		- Thordal
			- Aktive Fähigkeit: Gewährt zusätzlich den "Vielfältige Unterhaltung"-Bonus
			- Boni: Angriffskraft erhöht (25 -> 50) und Rekrutierung von Wikingern in Kasernen
		- Kestral
			- Bonus: Rekrutierung von Banditen in Kasernen (Art hängt von Klimazone ab)
		- Saraya
			- Aktive Fähigkeit: Mindest-Warenmenge erhöht (5 -> 9)
			- Passive Fähigkeit: Handelsposten noch billiger (50% -> 25%)
	- "Neue" Ritter implementiert
		- Crimson Sabatt
			- Aktive Fähigkeit: Konversion (wie Hakim)
			- Passive Fähigkeit: Bessere Handelskonditionen (wie Elias)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
		- Der Rote Prinz
			- Aktive Fähigkeit: Tribut (im Hauptspiel nur Gold, im AddOn wie Saraya)
			- Passive Fähigkeit: Höhere Steuern (wie Kestral)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
			- Für Mapper: 
				- Es gibt auskommentierte Codeschnippsel für eine "richtige" Seuchen-Fähigkeit
				- Wird zurzeit nicht verwendet, da im Mehrspieler nicht nutzbar
				- Wer sie nutzen will, kann sie womöglich reaktivieren
		- Khana
			- Aktive Fähigkeit: Versorgung von Soldaten mit Fackeln (wie Marcus)
			- Passive Fähigkeit: Mehr Gold von Predigten (wie Allandra)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
		- Praphat
			- Aktive Fähigkeit: Versorgung von Einwohnern mit Kleidung und gewährt "Vielfältige Kleidung"-Bonus (analog Elias/Thordal)
			- Passive Fähigkeit: Billigerer Ausbau von Gebäuden (wie Hakim)
		- Kastellane 
			- Können theoretisch als Ritter genutzt werden
			- Haben keine besonderen Fähigkeiten
		- Varianz an Ladebildschirm-Bildern
- Militär
	- Bogenschützen allgemein
		- Fernkampf-Schaden deutlich reduziert (30 -> 20)
		- Maximale Fernkampf-Reichweite leicht erhöht (24sm -> 25sm)
		- Ausnahme: Wikinger-Axtwerfer
	- Banditen 
		- Können in Kasernen wieder aufgefüllt werden
		- Haben ein eigenes Audio-Feedback
		- Können effektiver Gebäude anzünden
			- Schaden pro Fackel verdoppelt (5 -> 10)
			- Jeder Bandit trägt eine Fackel mehr (1 -> 2)
		- Fixes
			- Südeuropäische Banditen-Schwertkämpfer greifen nicht mehr automatisch Gebäude an
			- Asiatische Banditen haben keine Overhead-Namen mehr
	- Signatureinheiten vom Roten Prinzen und Khana 
		- Können in Kasernen wieder aufgefüllt werden
		- Haben ein anderes Audio-Feedback 
			- Zurzeit noch das von Banditen...
		- RP-Einheiten haben eine eigene Button-Textur
		- Khana-Einheiten haben keine Overhead-Namen mehr
	- "Neue" Einheiten
		- Hellebardiere
			- Inspiriert von den Hellebardieren in DEdK
			- Statuswerte (im Vergleich zu Schwertkämpfern)
				- Höhere Lebenspunkte (150 > 120)
				- Weniger Schaden (15 < 20)
				- Etwas höhere Reichweite (2sm > 1,5sm)
				- Langsamere Bewegungsgeschwindigkeit (420 < 480)
			- Zurzeit noch in Entwicklung
		- Raubtiere als kontrollierbare Militäreinheiten verfügbar
			- Konkret: Bären (3 Arten), Löwen (2 Arten), Wölfe (4 Arten), Tiger
		- Trebuchet
			- Funktioniert ähnlich wie ein Katapult
				- Höhere Maximalreichweite (32sm > 24sm)
				- Höhere Mindestreichweite (18sm > 10sm)
				- Höherer Schaden (100 > 50)
				- Geringere Feuerrate (7.5 Sek. > 5 Sek.)
				- Braucht länger zum Auf- und Abbau (8 Sek. > 5 Sek.)
			- Kann sich in aufgebauter Form nicht fortbewegen
			- Zurzeit noch nicht baubar, vllt. mit Titel "Erzherzog"?
	- Rammen können keine Mauern mehr angreifen
	- (Turm-)Katapulte und Trebuchets können Militäreinheiten aktiv angreifen
	- Mauerkatapulte abgeschwächt
		- Kosten mehr Eisen (5 -> 10)
		- Kosten mehr Gold (200 -> 300)
		- Schaden reduziert (50 -> 40)
		- Mindestreichweite erhöht (10sm -> 12sm)
		- Sind auf maximal 12 Stück gleichzeitig pro Spieler limitiert
	- Diebe
		- Sind auf maximal 6 Stück gleichzeitig pro Spieler limitiert
- Gebäude
	- Kirche
		- Mehr Siedler pro Predigt möglich
		- Einwohnerlimit pro Ausbaustufe erhöht
		- Eigenes Icon auf der Minimap
	- Burg
		- Soldatenlimit pro Ausbaustufe erhöht
		- Eigenes Icon auf der Minimap
	- Lagerhaus
		- Lagerkapazität der 3. und 4. Ausbaustufe erhöht
		- Eigenes Icon auf der Minimap
	- "Neue" Gebäude
		- Wachturm
			- Kostet 11 Steine
			- Kann mit einem Turmkatapult ausgerüstet wwerden
		- Aussichtsturm
			- Kostet 12 Steine
			- Besitzt eine hohe Sichtweite
			- Sieht einfach schick aus :)
	- Ziergebäude der Special Edition im Hauptspiel verfügbar
	- Bienenstöcke haben weniger Lebenspunkte (10 -> 5)
- Hauptmenü
	- AddOn nutzt weitgehend Hauptspiel-Hintergrund und Soundtrack
	- Hintergrund ist tageszeitabhängig
	- Kartenauswahl
		- Im AddOn wieder alle Ritter auswählbar, inklusive die Neuen
		- Ritter-Restriktionen erlauben jetzt die korrekte Sperrung einzelner Ritter
		- Filter
			- Im Einzelspieler nach Herkunft und Missionsziel
			- Im Mehrspieler nach Herkunft und maximaler Spieleranzahl
			- Wenn dadurch keine ausgewählt ist wird Mapvorschau geleert und Starten-Button deaktiviert
		- Im AddOn auch alle Hauptspiel-Karten auswählbar
- Diverses
	- Marcus wird nicht mehr als generischer Ritter gesetzt
	- Ungenutztes Audio-Feedback von Rittern, Soldaten und Dieben wird nun verwendet
	- Eisbären nutzen ihre richtige Sterbeanimation
	- Maximale bzw. Standard-Kapazität von Stein- und Eisenminen etwas erhöht (250 -> 300)
	- Geologeneinsätze kosten deutlich mehr Gold (250 -> 500)
	- Steuern
		- Maximale Anzahl an Steuereintreibern erhöht (6 -> 8)
	- Bei Minimap-Benachrichtigung wird der auslösende Spieler erst entfernt, um Verwirrung zu vermeiden
	- Neun "neue" Spielerfarben
	- Wappen
		- Textur ist im Beförderungs-Fenster nun richtig zentriert
		- Neue, von Stronghold 2 und Stronghold Legends inspirierte Wappen
	- Alternative Spielerfarbe: Gelb
		- Ist in den Optionen (de-)aktivierbar
		- Wirkt sich auch auf das gewählte Wappen aus
		- Hat keinen Einfluss auf den Multiplayer
	- Profil-Menü
		- Buttons haben nun alle einen Hover-Effekt
		- Speichern der Profileinstellungen funktioniert nun zuverlässig
	- Kampfmusik nach Klimazonen getrennt (als verschiedene Playlists)
	- Unterschiedliche Festival-Musik, je nachdem, ob der Anlass eine Heldenbeförderung oder ein normales Fest ist
	- Niederlagen-Kamerarotation deutlich verlangsamt
	- Sieg und Niederlage haben jeweils eine Art "Jingle"
	- Spielerfarben auf der Minimap sind nun (meistens) korrekt
- Kampagnen
	- Bugs gefixt
		- Verfrühte Meldungen von KI-Mitspielern (M05: Drengir, M09: Husran)
		- Verstärkung für den Spieler spawnt jetzt (M15: Vestholm)
	- KI-Spielerfarben
		- Mehr Varianz bei Spielerfarben
		- Konsistentere Spielerfarben im AddOn
	- Thronsaal hat einen eigenen Soundtrack
	- Diverses
		- M09: Husran: KI aggressiver
		- AM05: Idukun: durch etwas mehr Startkapital etwas einfacher



## (Mögliche) ToDos
- Speerkämpfer
	- Icon
	- Audio-Feedback
	- Rekrutierung
		- Eigener Warenkreislauf?
			- Gebäude
			- Waren
		- ODER: Der Nahkämpferkaserne hinzufügen
			- Neuer Button für die Kaserne
			- "Schwertkämpfer***"-Strings zu "Nahkämpfer***" abändern
	- Spielerfarbe abbilden (PU_SoldierPoleArm4_masks.dds)
- Außenposten/Aussichtsturm/Wachturm
	- ME-Aussichtsturm: Schwarze Seite
	- Aussichtstürme: Alarm?
	- Eigene Button-Texturen für Aussichtsturm und Wachturm
		- Wachturm: QuestInformation.Tower (mit Katapult), ...?
		- Aussichtsturm: PB_Tower1, Alarm, ...?
	- Generischer Außenposten, inkl. Katapult und Soldatenbemannung
- Spielerfarben
	- Minimap-Territorium-Farben weichen nach Neustart z.T. ab 
		- z.B. Dorf-Dunkelgrün -> Stadt-Grün
		- Beispiel: Der kalte Strom (Dorf)
		- Ist ein Vanilla-Bug!
	- KIs bekommen im MP die Spielerfarben ab Gelb (ValidPlayerColors property der Map vllt.?)
- Neue Wappen 
	- auf Ingame-Flaggen (statt Platzhalter) abbilden
- Hidun-Turnier: Neue Zelte und andere Siedler
	- Texturen für DEdK-Zelte gibt es schon
- Default custom maps
	- MP-Maps als Freibau-SP-Maps neu hinzufügen
		- Ggf. nicht alle Maps, nur die "schönsten"
		- Missionsziel ändern
		- Konkurrenten entfernen
		- Diplomatie setzen
	- Hauptspiel-Kampagne im AddOn
		- Zwischenmenü zur Auswahl der Kampagne
		- Slot für Community-Kampagnen
- Wikinger: Kontrollierter Ehefrauen-Raub
- RPG-Sicht zum rumlaufen ("Heist")
- Nutzbare (Tier-)Seuche, inkl. Musik
	- Ruhige, aber bedrohliche Playlist
	- Erst ab x% Betroffene, da sonst zu oft getriggert
- TTS
	- Ggf. Platzhalter
	- Notizen
		- Um +8db verstärken
		- ggf. Anfang und Ende kürzen
		- ggf. Geschwindigkeit -25%
		- Zu mp3 konvertieren
	- Stimmen
		- RedPrince-Units: Klaus Bauer
	- Ko-fi für GameTTS (als Schankedön)
- Nachrichten-Stau
- MP-Koop-Fixes
- AddOn-Kampagne-Loadscreens: Richtige Spielerfarben (per Bildbearbeitung)
- Baubares Trebuchet
	- Eigenes Karren-Modell
	- Eigene Icon-Texturen
	- Es dreht sich nicht richtig
	- Begleitende Sodaten bewegen sich nach einem Move nicht mehr korrekt
- Zahme Tiere: MilitaryFeedback global statt lokal
- Sturm
	- soll mal funktionieren
	- Abwandlung: Schneesturm
	- Eigene Playlist
- Verbesserte/Glaubwürdigere KI (in der Kampagne)
	- Allgemein: Konsequentere Nutzung von RP-/Khana-Einheiten sowie ggf. Söldner
	- Narfang: Sabatta aggressiv, wenn ein Außenposten erobert/zerstört wird
	- Husran: Eisenmine für Sabatta statt Eisen "frei Haus"
	- M15: Vestholm: Sturm
	- Idukun: Blizzard
	- Speziell in den "Last-Stand"-Missionen
	- Aktive KI-Ritter mit Fähigkeiten
	- Nutzlose Rand-Territorien weg
- Entlassen-Button
- Söldner-Trupps
	- Konvertierbar
	- Korrekte Fackelanzeige (auch im Base game)
- Max. Zoom leicht erhöhen
	- Winkel muss nach 0.5 anders kalkuliert werden
- "Neue" Ritter 
	- Khana und Praphat
		- Sprüche als Strings weiter anpassen
		- Audio-Feedback (TTS)
	- Kastellane: 
		- Sprüche als Strings
		- Audio-Feedback (TTS)
	- Bei Basegame-Rittern AddOn-Comments ergänzen (TTS)
	- RP: Seuchen-Fähigkeit umsetzen, falls GUI.SendScriptCommand irgendwann wieder laufen sollte
- Audio-Feedback für Ochsen
- Rebalancing
	- Neue (sinnvollere) Aufstiegsbedingungen
		- ggf. mit Indikator, um nur für neue Maps und angepasste zu gelten
		- wegen zu hohem Aufwand (Kompatibiliät mit alten Maps) erstmal Low Priority
	- Maximale Anzahl Steuereintreiber erhöhen (ggf. nur, wenn neue Einheiten verfügbar)
	- Soldatenlimit anheben (ggf. nur, wenn neue Einheiten verfügbar)
	- Rebalancing insb. für MP
	- Zwischenproduktionen einführen
		- Low Priority, da extrem viel Arbeit...
- Spielbare Dörfer?
- Ungenutzte Gebäude
	- Juwelier
	- Supermarkt?
- Fremder Content
	- Reiter
	- DEdK-Soundtrack
- Auf 4k-Auflösung kann nicht mehr per BorderScroll nach rechts gecrolled werden
- Biom-spezifisches Retexturing für Kerngebäude
	- Das oder neue Modelle
- Cheats am Ende komplett deaktivieren
- ReadMe auf Englisch
- Als bba gepackte Version für das Original
