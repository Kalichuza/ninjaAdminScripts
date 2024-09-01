[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$downloadPath = "C:\Windows\Temp",

    [Parameter(Mandatory = $false)]
    [string]$installerFileName = "Dell-Command-Update-Windows-Universal-Application_9M35M_WIN_5.4.0_A00.EXE",

    [Parameter(Mandatory = $false)]
    [string]$logFilePath = "C:\Windows\Temp\DellCommandUpdate_InstallLog.txt"
)

# Predefined URL for Dell Command Update
$downloadUrl = "https://dl.dell.com/FOLDER11914128M/1/Dell-Command-Update-Windows-Universal-Application_9M35M_WIN_5.4.0_A00.EXE"

function Download-File-InvokeWebRequest {
    param (
        [string]$url,
        [string]$destination
    )

    Write-Output "Downloading Dell Command Update from $url using Invoke-WebRequest with User-Agent spoofing..."
    try {
        $headers = @{}
        $headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
        Invoke-WebRequest -Uri $url -OutFile $destination -Headers $headers
        Write-Output "Download completed successfully. File saved to $destination"
    } catch {
        Write-Error "Failed to download the file from $url. Error: $_"
        exit 1
    }
}

function Install-DellCommandUpdate {
    param (
        [string]$installerPath,
        [string]$logPath
    )

    # Verify the file exists before proceeding
    if (-Not (Test-Path $installerPath)) {
        Write-Error "The installer file was not found at $installerPath. Exiting script."
        exit 1
    }

    Write-Output "Installer file located at $installerPath. Starting silent installation of Dell Command Update..."
    $arguments = "/s /l=`"$logPath`""
    $process = Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -PassThru
    if ($process.ExitCode -eq 0) {
        Write-Output "Dell Command Update installed successfully."
    } else {
        Write-Error "Installation failed with exit code $($process.ExitCode). Check the log file at $logPath for details."
    }
}

$installerFullPath = Join-Path -Path $downloadPath -ChildPath $installerFileName

# Download the installer using Invoke-WebRequest with User-Agent spoofing
Download-File-InvokeWebRequest -url $downloadUrl -destination $installerFullPath

# Log the path where the file is expected
Write-Output "Expected installer file path: $installerFullPath"

# Verify the installer was downloaded and install
Install-DellCommandUpdate -installerPath $installerFullPath -logPath $logFilePath
