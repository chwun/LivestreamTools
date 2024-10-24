# Function to load environment variables from a .env file
function Load-EnvFile {
    param (
        [string]$filePath
    )

    if (Test-Path $filePath) {
        Get-Content $filePath | ForEach-Object {
            if ($_ -match "^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$") {
                [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
            }
        }
    } else {
        Write-Host "The .env file was not found at $filePath"
        exit 1
    }
}

# Load environment variables from the .env file
$envFilePath = ".\.env"
Load-EnvFile -filePath $envFilePath

# Retrieve FTP credentials from environment variables
$ftpServer = [Environment]::GetEnvironmentVariable("FTP_HOST")
$ftpUsername = [Environment]::GetEnvironmentVariable("FTP_USER")
$ftpPassword = [Environment]::GetEnvironmentVariable("FTP_PASSWORD")
$fileName = "videoId.txt"

# Function to extract video ID from a YouTube URL
function Get-YouTubeVideoID {
    param (
        [string]$url
    )
    
    # Check if it's a standard YouTube URL
    if ($url -match 'youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})') {
        return $matches[1]
    }
    # Check if it's a shortened YouTube URL
    elseif ($url -match 'youtu\.be\/([a-zA-Z0-9_-]{11})') {
        return $matches[1]
    }
    # Check if it's a YouTube Live URL
    elseif ($url -match 'youtube\.com\/live\/([a-zA-Z0-9_-]{11})') {
        return $matches[1]
    }
    else {
        return $null
    }
}

# Show warning
Write-Host "-----------------------------------------------------------------------"
Write-Host "ACHTUNG: Dieses Skript ändert den Livestream-Link auf der Homepage!"
Write-Host "         Zum Abbrechen Strg+C drücken"
Write-Host "-----------------------------------------------------------------------"
Write-Host ""

# Prompt the user for a YouTube link
$youtubeLink = Read-Host "Vollständigen YouTube-Link eingeben"

# Extract the video ID from the YouTube link
$videoID = Get-YouTubeVideoID -url $youtubeLink

# Check if a valid video ID was extracted
if (-not $videoID) {
    Write-Host "YouTube-Link nicht erkannt, evtl. ungültiges Format?"
    exit 1
}

# Create a temporary text file with the extracted video ID
$tempFilePath = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFilePath -Value $videoID

# Define FTP URI for file upload
$ftpUri = "ftp://$ftpServer/$fileName"

# Set a global certificate validation callback to ignore SSL errors (not recommended in production)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }

# Create an FtpWebRequest object
$ftpRequest = [System.Net.FtpWebRequest]::Create($ftpUri)
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)

# Enable SSL for FTPS
$ftpRequest.EnableSsl = $true

# Suppress certificate errors (optional, consider validating the certificate in production)
# $ftpRequest.ServerCertificateValidationCallback = { $true }

# Read the file content into a byte array
$fileContent = [System.IO.File]::ReadAllBytes($tempFilePath)
$ftpRequest.ContentLength = $fileContent.Length

# Get the request stream and write the file content to it
try {
    $requestStream = $ftpRequest.GetRequestStream()
    $requestStream.Write($fileContent, 0, $fileContent.Length)
    $requestStream.Close()
    
    Write-Host "Livestream-Link erfolgreich gesetzt (video ID: $videoID)"
} catch {
    Write-Host "Fehler: $($_.Exception.Message)"
} finally {
    # Clean up temporary file
    Remove-Item $tempFilePath
}