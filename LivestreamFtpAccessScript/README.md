# Livestream-Tools: FTP-Zugriff für YouTube-Link

## Beschreibung

Powershell-Skript, das in der Konsole einen YouTube-Link entgegennimmt, die Video-Id daraus extrahiert und diese im FTP-Root-Verzeichnis in einer Datei `videoId.txt` ablegt.

## Setup

- Skript an beliebigem Ort ablegen
- .env-File nach Vorlage anlegen, Variablen setzen
- Für den einfachen Aufruf eine Verknüpfung zum Skript mit folgendem Aufruf anlegen (Pfad anpassen):  
`pwsh -ExecutionPolicy Bypass -File /pfad/zum/update-yt-link.ps1`