# Unofficial RoE Communitypatch
Dieser inoffizielle Patch behebt diverse Bugs vom Spiel 'Die Siedler - Aufstieg eines K�nigreichs' und f�gt neue Features hinzu.



## Installation
Mit folgenden Schritten l�sst sich der Patch installieren:
1. Projekt �ber Code -> Download ZIP herunterladen
2. Ordner in das AeK-Hauptverzeichnis entpacken
3. Zocken



## Features
Folgende �nderungen wurden vorgenommen:
- Ritter
	- "Alte" Ritter �berarbeitet
		- Allandra
			- Passive F�higkeiten: Bonusgold f�r Predigten erh�ht (20% -> 40%)
			- Bonus: Lebenspunkte leicht erh�ht (1.000 -> 1.100)
		- Elias
			- Passive F�higkeiten: Handelsbonus erh�ht (20% -> 40%)
		- Hakim
			- Aktive F�higkeit (Konversion)
				- Cooldown leicht erh�ht (7:30 Min. -> 8:00 Min.)
				- Kann nicht benutzt werden, wenn Soldatenlimit schon erreicht
		- Marcus
			- Bonus: Lebenspunkte leicht erh�ht (1.000 -> 1.100)
		- Thordal
			- Boni: Angriffskraft erh�ht (25 -> 40) und Rekrutierung von Wikingern in Kasernen
		- Kestral
			- Bonus: Rekrutierung von Banditen in Kasernen (Art h�ngt von Klimazone ab)
		- Saraya
			- Aktive F�higkeit: Mindest-Warenmenge erh�ht (5 -> 9)
			- Passive F�higkeit: Handelsposten noch billiger (50% -> 25%)
	- "Neue" Ritter implementiert
		- Crimson Sabatt
			- Aktive F�higkeit: Konversion (wie Hakim)
			- Passive F�higkeit: Bessere Handelskonditionen (wie Elias)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
		- Der Rote Prinz
			- Aktive F�higkeit: Tribut (im Hauptspiel nur Gold, im AddOn wie Saraya)
			- Passive F�higkeit: H�here Steuern (wie Kestral)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
			- F�r Mapper: 
				- Es gibt auskommentierte Codeschnippsel f�r eine "richtige" Seuchen-F�higkeit
				- Wird zurzeit nicht verwendet, da im Mehrspieler nicht nutzbar
				- Wer sie nutzen will, kann sie wom�glich reaktivieren
		- Khana
			- Aktive F�higkeit: Versorgung von Soldaten mit Fackeln (wie Marcus)
			- Passive F�higkeit: Mehr Gold von Predigten (wie Allandra)
			- Bonus: Rekrutierung von Signatureinheiten in Kasernen
		- Praphat
			- Aktive F�higkeit: Versorgung von Einwohnern mit Kleidung (analog Elias/Thordal)
			- Passive F�higkeit: Billigerer Ausbau von Geb�uden (wie Hakim)
		- Kastellane 
			- K�nnen theoretisch als Ritter genutzt werden
			- Haben keine besonderen F�higkeiten
		- Varianz an Ladebildschirm-Bildern
- Milit�r
	- Bogensch�tzen allgemein
		- Fernkampf-Schaden deutlich reduziert (30 -> 20)
		- Maximale Fernkampf-Reichweite leicht erh�ht (24sm -> 25sm)
		- Ausnahme: Wikinger-Axtwerfer
	- Banditen 
		- K�nnen in Kasernen wieder aufgef�llt werden
		- Haben ein eigenes Audio-Feedback
		- K�nnen effektiver Geb�ude anz�nden
			- Schaden pro Fackel verdoppelt (5 -> 10)
			- Jeder Bandit tr�gt eine Fackel mehr (1 -> 2)
		- Fixes
			- S�deurop�ische Banditen-Schwertk�mpfer greifen nicht mehr automatisch Geb�ude an
			- Asiatische Banditen haben keine Overhead-Namen mehr
	- Signatureinheiten vom Roten Prinzen und Khana 
		- K�nnen in Kasernen wieder aufgef�llt werden
		- Haben ein anderes Audio-Feedback 
			- Zurzeit noch das von Banditen...
		- RP-Einheiten haben eine eigene Button-Textur
		- Khana-Einheiten haben keine Overhead-Namen mehr
	- "Neue" Einheiten
		- Raubtiere als kontrollierbare Milit�reinheiten verf�gbar
			- Konkret: B�ren (3 Arten), L�wen (2 Arten), W�lfe (4 Arten), Tiger
		- Trebuchet
			- Funktioniert �hnlich wie ein Katapult
				- H�here Maximalreichweite (32sm > 24sm)
				- H�here Mindestreichweite (18sm > 10sm)
				- H�herer Schaden (100 > 50)
				- Geringere Feuerrate (7.5 Sek. > 5 Sek.)
				- Braucht l�nger zum Auf- und Abbau (8 Sek. > 5 Sek.)
			- Kann sich in aufgebauter Form nicht fortbewegen
			- Zurzeit noch nicht baubar, vllt. mit Titel "Erzherzog"?
	- Rammen k�nnen keine Mauern mehr angreifen
	- (Turm-)Katapulte und Trebuchets k�nnen Milit�reinheiten aktiv angreifen
	- Mauerkatapulte abgeschw�cht
		- Kosten mehr Eisen (5 -> 10)
		- Kosten mehr Gold (200 -> 300)
		- Schaden reduziert (50 -> 40)
		- Mindestreichweite erh�ht (10sm -> 12sm)
- Geb�ude
	- Kirche
		- Mehr Siedler pro Predigt m�glich
		- Einwohnerlimit pro Ausbaustufe erh�ht
		- Eigenes Icon auf der Minimap
	- Burg
		- Soldatenlimit pro Ausbaustufe erh�ht
		- Eigenes Icon auf der Minimap
	- Lagerhaus
		- Lagerkapazit�t der 3. und 4. Ausbaustufe erh�ht
		- Eigenes Icon auf der Minimap
	- "Neue" Geb�ude
		- Wachturm
			- Kostet 11 Steine
			- Kann mit einem Turmkatapult ausger�stet wwerden
		- Aussichtsturm
			- Kostet 12 Steine
			- Besitzt eine hohe Sichtweite
			- Sieht einfach schick aus :)
	- Ziergeb�ude der Special Edition im Hauptspiel verf�gbar
- Hauptmen�
	- AddOn nutzt weitgehend Hauptspiel-Hintergrund und Soundtrack
	- Hintergrund ist tageszeitabh�ngig
	- Kartenauswahl
		- Im AddOn wieder alle Ritter ausw�hlbar, inklusive die Neuen
		- Ritter-Restriktionen erlauben jetzt die korrekte Sperrung einzelner Ritter
		- Filter
			- Im Einzelspieler nach Herkunft und Missionsziel
			- Im Mehrspieler nach Herkunft und maximaler Spieleranzahl
			- Wenn dadurch keine ausgew�hlt ist wird Mapvorschau geleert und Starten-Button deaktiviert
		- Im AddOn auch alle Hauptspiel-Karten ausw�hlbar
- Diverses
	- Marcus wird nicht mehr als generischer Ritter gesetzt
	- Ungenutztes Audio-Feedback von Rittern, Soldaten und Dieben wird nun verwendet
	- Eisb�ren nutzen ihre richtige Sterbeanimation
	- Maximale bzw. Standard-Kapazit�t von Stein- und Eisenminen etwas erh�ht (250 -> 300)
	- Geologeneins�tze kosten deutlich mehr Gold (250 -> 500)
	- Steuern
		- Maximale Anzahl an Steuereintreibern erh�ht (6 -> 8)
	- Bei Minimap-Benachrichtigung wird der ausl�sende Spieler erst entfernt, um Verwirrung zu vermeiden
	- Neun "neue" Spielerfarben
	- Wappen
		- Textur ist im Bef�rderungs-Fenster nun richtig zentriert
		- Neue, von Stronghold 2 und Stronghold Legends inspirierte Wappen
	- Alternative Spielerfarbe: Gelb
		- Ist in den Optionen (de-)aktivierbar
		- Wirkt sich auch auf das gew�hlte Wappen aus
		- Hat keinen Einfluss auf den Multiplayer
	- Profil-Men�
		- Buttons haben nun alle einen Hover-Effekt
		- Speichern der Profileinstellungen funktioniert nun zuverl�ssig
	- Kampfmusik nach Klimazonen getrennt (als verschiedene Playlists)
	- Unterschiedliche Festival-Musik, je nachdem, ob der Anlass eine Heldenbef�rderung oder ein normales Fest ist
	- Niederlagen-Kamerarotation deutlich verlangsamt
	- Sieg und Niederlage haben jeweils eine Art "Jingle"
	- Spielerfarben auf der Minimap sind nun (meistens) korrekt
- Kampagnen
	- Bugs gefixt
		- Verfr�hte Meldungen von KI-Mitspielern (M05: Drengir, M09: Husran)
		- Verst�rkung f�r den Spieler spawnt jetzt (M15: Vestholm)
	- KI-Spielerfarben
		- Mehr Varianz bei Spielerfarben
		- Konsistentere Spielerfarben im AddOn
	- Thronsaal hat einen eigenen Soundtrack
	- Diverses
		- M09: Husran: KI aggressiver
		- AM05: Idukun: durch etwas mehr Startkapital etwas einfacher



## (M�gliche) ToDos
- Au�enposten/Aussichtsturm/Wachturm
	- ME-Aussichtsturm: Schwarze Seite
	- Aussichtst�rme: Alarm?
	- Eigene Button-Texturen f�r Aussichtsturm und Wachturm
		- Wachturm: QuestInformation.Tower (mit Katapult), ...?
		- Aussichtsturm: PB_Tower1, Alarm, ...?
	- Generischer Au�enposten, inkl. Katapult und Soldatenbemannung
- Spielerfarben
	- Minimap-Territorium-Farben weichen nach Neustart z.T. ab 
		- z.B. Dorf-Dunkelgr�n -> Stadt-Gr�n
		- Beispiel: Der kalte Strom (Dorf)
		- Ist ein Vanilla-Bug!
	- KIs bekommen im MP die Spielerfarben ab Gelb (ValidPlayerColors property der Map vllt.?)
- Neue Wappen 
	- auf Ingame-Flaggen (statt Platzhalter) abbilden
- Hidun-Turnier: Neue Zelte und andere Siedler
	- Texturen f�r DEdK-Zelte gibt es schon
- Default custom maps
	- MP-Maps als Freibau-SP-Maps neu hinzuf�gen
		- Ggf. nicht alle Maps, nur die "sch�nsten"
		- Missionsziel �ndern
		- Konkurrenten entfernen
		- Diplomatie setzen
	- Hauptspiel-Kampagne im AddOn
		- Zwischenmen� zur Auswahl der Kampagne
		- Slot f�r Community-Kampagnen
- Musik
	- Playlists fixen (wenn n�tig)
	- Soundtrack aus DEdK (ggf. per externem Tool...)
- Wikinger: Kontrollierter Ehefrauen-Raub
- RPG-Sicht zum rumlaufen
- Nutzbare (Tier-)Seuche, inkl. Musik
	- Ruhige, aber bedrohliche Playlist
	- Erst ab x% Betroffene, da sonst zu oft getriggert
- TTS
	- Ggf. Platzhalter
	- Notizen
		- Um +8db verst�rken
		- ggf. Anfang und Ende k�rzen
		- ggf. Geschwindigkeit -25%
		- Zu mp3 konvertieren
	- Stimmen
		- RedPrince-Units: Klaus Bauer
	- Ko-fi f�r GameTTS (als Schanked�n)
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
- Verbesserte/Glaubw�rdigere KI (in der Kampagne)
	- Allgemein: Konsequentere Nutzung von RP-/Khana-Einheiten sowie ggf. S�ldner
	- Narfang: Sabatta aggressiv, wenn ein Au�enposten erobert/zerst�rt wird
	- Husran: Eisenmine f�r Sabatta statt Eisen "frei Haus"
	- M15:Vestholm: Sturm
	- Idukun: Blizzard
	- Speziell in den "Last-Stand"-Missionen
	- Aktive KI-Ritter mit F�higkeiten
	- Nutzlose Rand-Territorien weg
- Entlassen-Button
- S�ldner-Trupps
	- Konvertierbar
	- Korrekte Fackelanzeige (auch im Base game)
- Max. Zoom leicht erh�hen
	- Winkel muss nach 0.5 anders kalkuliert werden
- "Neue" Ritter 
	- Khana und Praphat
		- Spr�che als Strings weiter anpassen
		- Audio-Feedback (TTS)
	- Kastellane: 
		- Spr�che als Strings
		- Audio-Feedback (TTS)
	- Bei Basegame-Rittern AddOn-Comments erg�nzen (TTS)
	- RP: Seuchen-F�higkeit umsetzen, falls GUI.SendScriptCommand irgendwann wieder laufen sollte
- Audio-Feedback f�r Ochsen
- Rebalancing
	- Mauern erst ab Landvogt/Baron?
	- Mauerkatapulte erst ab Marquis?
	- Max. Anzahl Wacht�rme regulieren? -> z.B. 10
	- Max. Anzahl Diebe regulieren? -> z.B. 10
	- Neue (sinnvollere) Aufstiegsbedingungen
		- ggf. mit Indikator, um nur f�r neue Maps und angepasste zu gelten
		- wegen zu hohem Aufwand (Kompatibili�t mit alten Maps) erstmal Low Priority
	- Maximale Anzahl Steuereintreiber erh�hen (ggf. nur, wenn neue Einheiten verf�gbar)
	- Soldatenlimit anheben (ggf. nur, wenn neue Einheiten verf�gbar)
	- Rebalancing insb. f�r MP
	- Zwischenproduktionen einf�hren
		- Low Priority, da extrem viel Arbeit...
- Spielbare D�rfer?
- Ungenutzte Geb�ude
	- Juwelier
	- Supermarkt?
- Fremder Content
	- Speerk�mpfer
		- Defensiv und offensiv schw�cher
		- Leicht erh�hte Reichweite, billiger und mit Bonusschaden gegen Ritter
	- Kanonen (macht twA)
	- Reiter
- Auf 4k-Aufl�sung kann nicht mehr per BorderScroll nach rechts gecrolled werden
- Biom-spezifisches Retexturing f�r Kerngeb�ude
	- Das oder neue Modelle
- Cheats am Ende komplett deaktivieren
- ReadMe auf Englisch
- Als bba gepackte Version f�r das Original