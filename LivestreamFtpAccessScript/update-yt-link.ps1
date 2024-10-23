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
$ftpServer = [Environment]::GetEnvironmentVariable("FTP_SERVER")
$ftpUsername = [Environment]::GetEnvironmentVariable("FTP_USERNAME")
$ftpPassword = [Environment]::GetEnvironmentVariable("FTP_PASSWORD")
$ftpDirectory = [Environment]::GetEnvironmentVariable("FTP_DIRECTORY")
$fileName = "youtube_video_id.txt"

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
    else {
        return $null
    }
}

# Prompt the user for a YouTube link
$youtubeLink = Read-Host "Please enter a YouTube link"

# Extract the video ID from the YouTube link
$videoID = Get-YouTubeVideoID -url $youtubeLink

# Check if a valid video ID was extracted
if (-not $videoID) {
    Write-Host "Invalid YouTube link. Could not extract a valid video ID."
    exit 1
}

# Create a temporary text file with the extracted video ID
$tempFilePath = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFilePath -Value $videoID

# Define FTP URI for file upload
$ftpUri = "$ftpServer$ftpDirectory$fileName"

# Create a WebClient object
$webClient = New-Object System.Net.WebClient

# Add FTP credentials to the WebClient object
$webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)

# Upload the file to the FTP server
try {
    $webClient.UploadFile($ftpUri, $tempFilePath)
    Write-Host "File uploaded successfully with video ID: $videoID"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
} finally {
    # Clean up temporary file
    Remove-Item $tempFilePath
}

# Dispose of the WebClient object
$webClient.Dispose()
