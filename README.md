# Unofficial RoE Communitypatch
Dieser inoffizielle Patch behebt diverse Bugs vom Spiel 'Die Siedler - Aufstieg eines Königreichs' und fügt neue Features hinzu.



## Installation
Mit folgenden Schritten lässt sich der Patch installieren:
1. Projekt über Code -> Download ZIP herunterladen
2. Ordner in das AeK-Hauptverzeichnis entpacken
3. Zocken



## Features
Folgende Änderungen wurden vorgenommen:
- Allgemein
	- Marcus wird nicht mehr als generischer Ritter gesetzt
- Ritter
	- Passive Fähigkeiten
		- Allandra: Bonusgold für Predigten erhöht (20% -> 40%)
	- Neue Bonus-Fähigkeiten für manche Ritter
		- Leicht veränderte Statuswerte
			- Marcus: Lebenspunkte leicht erhöht (1.000 -> 1.100)
			- Allandra: Lebenspunkte leicht erhöht (1.000 -> 1.100)
			- Thordal: Angriffskraft erhöht (25 -> 40)
		- Thordal: Rekrutierung von Wikingern in Kasernen
		- Kestral: Rekrutierung von Banditen in Kasernen (Art hängt von Klimazone ab)
	- "Neue" Ritter
		- Crimson Sabatt
			- Aktive Fähigkeit: Konversion
			- Passive Fähigkeit: Bessere Handelskonditionen
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
		- Der Rote Prinz
			- Aktive Fähigkeit: Tribut
			- Passive Fähigkeit: Höhere Steuern
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
			- Für Mapper: 
				- Es gibt auskommentierte Codeschnippsel für eine "richtige" Seuchen-Fähigkeit
				- Wird zurzeit nicht verwendet, da im Mehrspieler nicht nutzbar
				- Wer sie nutzen will, kann sie womöglich reaktivieren
		- Khana
			- Aktive Fähigkeit: Versorgung von Sodaten mit Fackeln
			- Passive Fähigkeit: Mehr Gold von Predigten (40%)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
		- Praphat
			- Aktive Fähigkeit: Versorgung von Einwohnern mit Kleidung
			- Passive Fähigkeit: Billigerer ausbau von Gebäuden
		- Kastellane können theoretisch als Ritter genutzt werden
- Militär
	- Banditen 
		- Können in Kasernen wieder aufgefüllt werden
		- Haben ein eigenes Audio-Feedback
		- Fix: Südeuropäische Banditen-Schwertkämpfer greifen nicht mehr automatisch Gebäude an
	- Signatureinheiten vom Roten Prinzen und Khana 
		- Können in Kasernen wieder aufgefüllt werden
		- Haben ein anderes Audio-Feedback 
			- Zurzeit noch das von Banditen...
	- "Neue" Einheiten
		- Raubtieren als kontrollierbare Militäreinheiten verfügbar
			- Konkret: Bären (3 Arten), Löwen (2 Arten), Wölfe (4 Arten), Tiger
		- Trebuchet
			- Funktioniert ähnlich wie ein Katapult
				- Höhere Maximalreichweite (3.600 > 2.400)
				- Höhere Mindestreichweite (1.800 > 1.000)
				- Höherer Schaden (100 > 50)
				- Geringere Feuerrate (7.5 Sek > 5 Sek)
				- Braucht länger zum Auf- und Abbau (8.000 > 5.000)
			- Kann sich in aufgebauter Form nicht fortbewegen
			- Zurzeit noch nicht baubar
	- Rammen können keine Mauern mehr angreifen
	- (Turm-)Katapulte und Trebuchets können Militäreinheiten aktiv angreifen
	- Mauerkatapulte abgeschwächt
		- Kosten mehr Eisen (5 -> 10)
		- Kosten mehr Gold (200 -> 300)
		- Schaden reduziert (50 -> 40)
		- Mindestreichweite erhöht (1.000 -> 1.200)
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
- Hauptmenü
	- AddOn nutzt weitgehend Hauptspiel-Hintergrund und Soundtrack
	- Hintergrund ist tageszeitabhängig
	- Kartenauswahl
		- Im AddOn wieder alle Ritter auswählbar, inklusive die Neuen
		- Filter
			- Im Einzelspieler nach Herkunft und Missionsziel
			- Im Mehrspieler nach Herkunft und maximaler Spieleranzahl
			- Wenn dadurch keine ausgewählt ist wird Mapvorschau geleert und Starten-Button deaktiviert
- Diverses
	- Eisbären nutzen nun ihre richtige Sterbeanimation
	- Maximale bzw. Standard-Kapazität von Stein- und Eisenminen etwas erhöht (250 -> 300)
	- Geologeneinsätze kosten deutlich mehr (250 -> 500)
	- Steuern
		- Maximale Anzahl an Steuereintreibern erhöht (6 -> 8)
	- Bei Minimap-Benachrichtigung wird der auslösende Spieler erst entfernt, um Verwirrung zu vermeiden
	- Neuen "neue" Spielerfarben
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
- Kampagnen
	- Bugs gefixt
		- Verfrühte Meldungen von KI-Mitspielern (M05: Drengir, M09: Husran)
		- Verstärkung für den Spieler spawnt nicht (M15: Vestholm)
	- KI aggressiver
		- M09: Husran
	- KI-Spielerfarben
		- Mehr Varianz bei Spielerfarben
		- Konsistentere Spielerfarben im AddOn
	- Thronsaal hat einen eigenen Soundtrack



## ToDos
Folgende Features sind geplant, aber noch nicht umgesetzt:
1. Als bba gepackte Version für das "alte" AeK
2. GGf. weitere Modifikationen über den Patch hinaus (aber in einem anderen Branch bzw. Projekt)