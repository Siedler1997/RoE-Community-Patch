# Unofficial RoE Communitypatch
Dieser inoffizielle Patch behebt diverse Bugs der History Edition vom Spiel 'Die Siedler - Aufstieg eines Königreichs' und fügt neue Features hinzu.



## Installation
Mit folgenden Schritten lässt sich der Patch installieren:
1. Lege eine Sicherheitskopie von `extra1` unter dem Namen `extra1_orig` an.
Extra1 findest du unter The `Settlers - Rise of an Empire - History Edition\Data`. Du kannst die Kopie nennen, wie du willst.
2. Projekt über Code -> Download ZIP herunterladen
3. Kopiere den `Data` Ordner in der Zip nach `Settlers - Rise of an Empire - History Edition` und bstätige das Überschreiben.
4. Ändere die Starteinstellungen in Steam bzw. Uplay, sodass das Programm mit `-EXTRA1` als Parameter ausgeführt wird.
3. Zocken


## Deinstallation
Mit folgenden Schritten lässt sich der Patch deinstallieren:
1. Lösche `Settlers - Rise of an Empire - History Edition\Data\extra1`.
2. Benenne die Sicherheitskopie von `extra1_orig` in `extra1` um.
3. Entferne `-EXTRA1` aus den Startoptionen von Steam bzw. Uplay.
4. Vanilla zocken



## Features
Folgende Änderungen wurden vorgenommen:
- Ritter
	- Haben nun je 3 "Fackeln", um Gebäude angreifen zu können
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
			- Aktive Fähigkeit: Tribut (wie Saraya)
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
	- Einheiten können mittels Entlassen-Button ... entlassen werden
	- Bogenschützen allgemein
		- Fernkampf-Schaden deutlich reduziert (30 -> 20)
		- Maximale Fernkampf-Reichweite leicht erhöht (24sm -> 25sm)
		- Ausnahme: Wikinger-Axtwerfer
	- Banditen 
		- Können in Kasernen wieder aufgefüllt werden
		- Haben ein eigenes Audio-Feedback
		- Haben etwas andere Statuswerte ggü. konventionellen Einheiten
			- Weniger Lebenspunkte (-5)
			- Höhere Bewegungsgeschwindigkeit (480 < 500)
			- Höherer Schaden gegen Gebäude (5 -> 10)
			- Eine Fackel mehr (1 -> 2)
		- Fixes
			- Südeuropäische Banditen-Schwertkämpfer greifen nicht mehr automatisch Gebäude an
			- Asiatische Banditen haben keine Overhead-Namen mehr
	- Signatureinheiten vom Roten Prinzen und Khana 
		- Können in Kasernen wieder aufgefüllt werden
		- Haben ein anderes Audio-Feedback 
			- Zurzeit noch das von Banditen...
		- Haben etwas andere Statuswerte ggü. konventionellen Einheiten
			- RP
				- Weniger Lebenspunkte (-5)
				- Höhere Bewegungsgeschwindigkeit (480 < 490)
			- Khana
				- Weniger Lebenspunkte (-10)
				- Höhere Bewegungsgeschwindigkeit (480 < 500)
				- Höherer Schaden gegen anderen Einheiten (20 < 22)
		- RP-Einheiten haben eine eigene Button-Textur
		- Khana-Einheiten haben keine Overhead-Namen mehr
	- "Neue" Einheiten
		- Lanzenträger
			- Inspiriert von den Streitlanzenträgern in DEdK
			- Statuswerte (im Vergleich zu Schwertkämpfern)
				- Höhere Lebenspunkte (180 > 120)
				- Weniger Schaden (15 < 20)
				- Etwas höhere Reichweite (2sm > 1,5sm)
				- Langsamere Bewegungsgeschwindigkeit (420 < 480)
		- Hellebardiere
			- Basieren auf den Hellebardieren in DEdK
			- Haben noch etwas bessere Stats als Streitlanzenträger
			- Sind Einzelgänger
			- NICHT rekrutierbar, aber kontrollierbar
				- Für Mapper: Gut nutzbar als NPCs bzw. Dekoration
		- Raubtiere als kontrollierbare Militäreinheiten verfügbar
			- Konkret: Bären (3 Arten), Löwen (2 Arten), Wölfe (4 Arten), Tiger
		- Trebuchet
			- Funktioniert ähnlich wie ein Katapult
				- Höhere Maximalreichweite (32sm > 24sm)
				- Höhere Mindestreichweite (18sm > 10sm)
				- Höherer Schaden (100 > 50)
				- Geringere Feuerrate (8 Sek. > 5 Sek.)
				- Braucht länger zum Auf- und Abbau (8 Sek. > 5 Sek.)
			- Kann sich in aufgebauter Form nicht fortbewegen
			- Muss nicht von Soldaten bedient werden
			- Zurzeit noch nicht baubar, vllt. mit Titel "Erzherzog"?
		- Geister-Ochse in Anlehnung an Ubis Raketen Ochsen ;)
	- "Alte" Trebuchets
		- Richtiges Selektionsmenü
		- Eigener Tooltip-String
		- Mit Munition belieferbar
		- Diverse Anpassungen auf Basis des "neuen" Trebuchets
	- Rammen können keine Mauern mehr angreifen
	- (Turm-)Katapulte und Trebuchets können Militäreinheiten aktiv angreifen
	- Overhead und SelectionMenu vom Gefängniskarren den anderen Karren angeglichen
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
		- Spielerwappen wird nicht mehr auf dem Banner am Eingang abgebildet
			- Technisch leider zwecks Konsistenz zwischen alten und neuen Wappen notwendig
	- Lagerhaus
		- Lagerkapazität der 3. und 4. Ausbaustufe erhöht
		- Eigenes Icon auf der Minimap
	- Marktplatz: Generische Ritter-Statue bei Khana, Praphat und Kastellanen
	- "Neue" Gebäude
		- Wachturm
			- Kostet 11 Steine
			- Kann mit einem Turmkatapult ausgerüstet wwerden
		- Aussichtsturm
			- Kostet 12 Steine
			- Besitzt eine hohe Sichtweite
			- Sieht einfach schick aus :)
		- AS-Zelte mit entsprechenden Workern
	- NPC-Gebäude
		- RP-/Khana-Kasernen
			- Funktionieren unter Spieler-Kontrolle wie normale Kasernen auch
			- Ermöglichen, unabhängig vom Ritter, Rekrutierung von RP- bzw. Khana-Einheiten
		- Alle NPC-Gebäude mit Menü
			- Sollten nun einen Namens-String haben
			- Zeigen die Ausbaustufe "1/1" an
		- Hauptspiel-Marktplätze haben ein Mouseover
	- Bienenstöcke haben weniger Lebenspunkte (10 -> 5)
	- Handelsposten-Baubutton hat einen etwas verständlicheren Tooltip
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
	- Automatisches Schnellspeichern deaktiviert
		- Für Mapper: Quicksave wurde über neue Funktion umgeleitet: KeyBindings_SaveGame_Neu()
	- Teardown-Sound von Palisaden/Mauern etwas leiser
	- Marcus wird nicht mehr als generischer Ritter gesetzt
	- Ungenutztes Audio-Feedback von Rittern, Soldaten und Dieben wird nun verwendet
	- Eisbären nutzen ihre richtige Sterbeanimation
	- Maximale bzw. Standard-Kapazität von Stein- und Eisenminen etwas erhöht (250 -> 300)
	- Geologeneinsätze 
		- Kosten deutlich mehr Gold (250 -> 500)
		- Haben einen verständlicheren Tooltip sowie einen eigenen Disabled-Tooltip
		- Für Mapper: Können mit den neuen Technologien 'R_RefillStoneMine', 'R_RefillIronMine' und 'R_RefillCistern' verboten werden
	- Steuern
		- Maximale Anzahl an Steuereintreibern erhöht (6 -> 8)
	- Bei Minimap-Benachrichtigung wird der auslösende Spieler erst entfernt, um Verwirrung zu vermeiden
	- Neun "neue" Spielerfarben
	- Profil-Menü
		- Buttons haben nun alle einen Hover-Effekt
		- Speichern der Profileinstellungen funktioniert nun zuverlässig
		- Neue Wappen hinzugefügt
			- Textur ist im Beförderungs-Fenster nun richtig zentriert
			- Neue, von Stronghold 2 und Legends inspirierte Wappen
		- Option für alternative Spielerfarbe: Gelb
			- Wirkt sich auf das gewählte Wappen und ALLE Maps aus
			- Hat keinen Einfluss auf den Multiplayer
	- Kampfmusik nach Klimazonen getrennt (als verschiedene Playlists)
	- Baumenü: BeautificationMenu verschönert
	- Unterschiedliche Festival-Musik, je nachdem, ob der Anlass eine Heldenbeförderung oder ein normales Fest ist
	- Niederlagen-Kamerarotation deutlich verlangsamt
	- Sieg und Niederlage haben jeweils eine Art "Jingle"
	- Spielerfarben auf der Minimap sind nun (meistens) korrekt
	- Krankheiten treten nun schon ab 101 Siedlern auf, nicht erst ab 151
	- Minimap
		- Alle Icons um 25% verkleinert
		- Au�enposten, Handelsposten und Khanas Tempel werden ebenfalls angezeigt
    - NPC Charaktere k�nnen nicht mehr Spieler 0 angeh�ren
- Kampagnen
	- Hauptspiel-Kampagne auch im AddOn spielbar
	- Bugs gefixt
		- Verfrühte Meldungen von KI-Mitspielern (M05: Drengir, M09: Husran)
		- Verstärkung für den Spieler spawnt jetzt (M15: Vestholm)
		- KI verliert am Anfang der Mission keine Territorien mehr (M09: Husran)
		- Unnütze Randterritorien in benachbarte eingegliedert (M14: Gueranna)
	- KI-Spielerfarben
		- Mehr Varianz bei Spielerfarben
		- Konsistentere Spielerfarben im AddOn
	- Thronsaal 
		- Hat einen eigenen Soundtrack
		- Tür wird von Hellebardieren bewacht
	- Diverses
		- M09: Husran: KI aggressiver und mit eigener Eisenmine
		- AM05: Idukun: durch etwas mehr Startkapital etwas einfacher