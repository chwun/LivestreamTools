# Livestream-Tools: FTP-Zugriff für YouTube-Id

## Beschreibung

Python-Skript, das eine YouTube-Id entgegennimmt und diese im FTP-Root-Verzeichnis in einer Datei `videoId.txt` ablegt.

## Setup

### Ggf. virtuelle Umgebung erstellen und aktivieren

```
python -m venv .venv
.venv\scripts\activate
```

### Python-Module installieren

```
pip install -r requirements.txt
```

### .env-Datei mit Umgebungsvariablen anlegen

Benötigt werden FTP-Host, User und Passwort.

```python
FTP_HOST = 'www.example.com'
FTP_USER = 'userXYZ'
FTP_PASSWORD = 'password'
```
