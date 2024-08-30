# Define parameters
param (
    [string]$imagePath,      # Path to the local image file
    [string]$downloadUrl     # URL to download the image file from GitHub
)

# Function to download the image from GitHub
function Download-LockScreenImage {
    param (
        [string]$url,
        [string]$destination
    )

    try {
        Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
        Write-Host "Image downloaded successfully to $destination"
    } catch {
        Write-Host "Failed to download the image: $_"
        exit 1
    }
}

# Function to set the lock screen image
function Set-LockScreenImage {
    param (
        [string]$imagePath
    )

    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
    $regValue = "LockScreenImage"

    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the lock screen image registry key
    Set-ItemProperty -Path $regPath -Name $regValue -Value $imagePath -Force

    Write-Host "Lock screen image set to: $imagePath"
}

# Main logic
if ($downloadUrl) {
    $localImagePath = "C:\Windows\Web\Screen\lockscreen.jpg"
    Download-LockScreenImage -url $downloadUrl -destination $localImagePath
    Set-LockScreenImage -imagePath $localImagePath
} elseif ($imagePath) {
    if (Test-Path $imagePath) {
        Set-LockScreenImage -imagePath $imagePath
    } else {
        Write-Host "The specified local image path does not exist: $imagePath"
        exit 1
    }
} else {
    Write-Host "Please provide either a local image path or a download URL."
    exit 1
}

# Refresh the lock screen
rundll32.exe user32.dll, UpdatePerUserSystemParameters
