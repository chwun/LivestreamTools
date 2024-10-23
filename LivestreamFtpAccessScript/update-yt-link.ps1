# Define FTP credentials and server details
$ftpServer = "ftp://yourserver.com"
$ftpUsername = "yourUsername"
$ftpPassword = "yourPassword"
$ftpDirectory = "/path/on/ftp/server/"
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
