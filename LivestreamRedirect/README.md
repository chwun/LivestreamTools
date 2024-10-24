# Livestream-Tools: Weiterleitung auf YouTube-Video

## Beschreibung

PHP-Skript, das eine YouTube-Id aus einer Datei `data/videoId.txt` ausliest und per HTTP-Header auf das entsprechende Video weiterletet.

## Setup

- Auf Webserver ein Verzeichnis anlegen, dessen Pfad zur Weiterleitung genutzt werden soll (bspw. "livestream").
- Datei `index.php` ablegen. Das PHP-Skript führt die automatische Weiterleitung zum YouTube-Video durch.
- Datei `.htaccess` ablegen. Damit wird das Unterverzeichnis `data` für den direkten Zugriff gesperrt.
- Unterverzeichnis `data` anlegen, dieses Verzeichnis als Root für einen speziellen FTP-Nutzer einrichten.
