# Set VerbosePreference to capture verbose output
$VerbosePreference = "Continue"

# Function to log and handle errors
function Log-Error {
    param (
        [string]$Message
    )
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

# Function to log command output
function Log-Output {
    param (
        [string]$Message
    )
    Write-Host $Message
}

# Function to stop processes using a file
function Stop-ProcessesUsingFile {
    param (
        [string]$FilePath
    )
    $processes = Get-Process | ForEach-Object {
        try {
            $_.Modules | Where-Object { $_.FileName -eq $FilePath }
        } catch {
            # Ignore errors accessing process modules
        }
    }

    if ($processes) {
        foreach ($process in $processes) {
            try {
                Stop-Process -Id $process.Id -Force
                Log-Output "Stopped process $($process.Name) (ID: $($process.Id)) using $FilePath"
            } catch {
                Log-Error "Failed to stop process $($process.Name) (ID: $($process.Id)). $_"
            }
        }
    } else {
        Log-Output "No processes found using $FilePath."
    }
}

# Download and install NuGet provider
Log-Output "Downloading and installing NuGet provider..."
$nugetUrl = "https://onegetcdn.azureedge.net/providers/Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"
$tempDestination = "$env:TEMP\Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"
$nugetDestination = "C:\Program Files\PackageManagement\ProviderAssemblies\Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"
try {
    Invoke-WebRequest -Uri $nugetUrl -OutFile $tempDestination -Verbose
    Log-Output "NuGet provider downloaded to temporary location."

    # Ensure the destination directory exists
    if (-not (Test-Path -Path "C:\Program Files\PackageManagement\ProviderAssemblies")) {
        New-Item -ItemType Directory -Path "C:\Program Files\PackageManagement\ProviderAssemblies" -Force
    }

    # Stop processes using the DLL
    Stop-ProcessesUsingFile -FilePath $nugetDestination

    # Copy the file to the correct location with elevated permissions
    Copy-Item -Path $tempDestination -Destination $nugetDestination -Force

    # Small pause to ensure the system recognizes the new DLL
    Start-Sleep -Seconds 2

    # Import the package provider
    Import-PackageProvider -Name NuGet -Force
    Log-Output "NuGet provider installed successfully."
} catch {
    Log-Error "Failed to install NuGet provider. $_"
}

# Refresh the environment to ensure the NuGet provider is recognized
Log-Output "Refreshing the environment to ensure the NuGet provider is recognized..."
$env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PSModulePath", $env:PSModulePath, [System.EnvironmentVariableTarget]::Process)

# Pre-accept the repository source
$repository = "PSGallery"
Log-Output "Checking if PSGallery repository is registered..."
if (-not (Get-PSRepository -Name $repository -ErrorAction SilentlyContinue)) {
    Log-Output "PSGallery repository not found. Registering PSGallery repository..."
    try {
        $registerOutput = Register-PSRepository -Default -Verbose 4>&1
        $registerOutput | ForEach-Object { Log-Output $_ }
        Log-Output "PSGallery repository registered successfully."
    } catch {
        Log-Error "Failed to register PSGallery repository. $_"
    }
} else {
    Log-Output "PSGallery repository is already registered."
}

# Pre-accept the installation policy for the repository
Log-Output "Setting installation policy for PSGallery repository to Trusted..."
try {
    $policyOutput = Set-PSRepository -Name $repository -InstallationPolicy Trusted -Verbose 4>&1
    $policyOutput | ForEach-Object { Log-Output $_ }
    Log-Output "Installation policy set to Trusted."
} catch {
    Log-Error "Failed to set installation policy for PSGallery repository. $_"
}

# Set the default script installation path and add it to the PATH environment variable
$scriptInstallPath = "C:\Program Files\WindowsPowerShell\Scripts"
Log-Output "Adding default script installation path to PATH environment variable..."
if ($env:Path -notlike "*$scriptInstallPath*") {
    $env:Path += ";$scriptInstallPath"
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::User)
    Log-Output "Default script installation path added to PATH."
} else {
    Log-Output "Default script installation path is already in PATH."
}

# Create the script installation directory if it doesn't exist
Log-Output "Checking if script installation directory exists..."
if (-not (Test-Path -Path $scriptInstallPath)) {
    Log-Output "Script installation directory not found. Creating directory..."
    try {
        $createDirOutput = New-Item -ItemType Directory -Path $scriptInstallPath -Force -Verbose 4>&1
        $createDirOutput | ForEach-Object { Log-Output $_ }
        Log-Output "Script installation directory created successfully."
    } catch {
        Log-Error "Failed to create script installation directory. $_"
    }
} else {
    Log-Output "Script installation directory already exists."
}

# Install a well-known script to validate the setup
$testScriptName = "Get-InstalledSoftware"
Log-Output "Installing test script '$testScriptName' to validate the setup..."
try {
    $installScriptOutput = Install-Script -Name $testScriptName -Force -Scope AllUsers -Verbose 4>&1
    $installScriptOutput | ForEach-Object { Log-Output $_ }
    Log-Output "Test script '$testScriptName' installed successfully."
} catch {
    Log-Error "Failed to install test script '$testScriptName'. $_"
}

# Validate the installation of the test script
Log-Output "Validating the installation of the test script '$testScriptName'..."
$installedScript = Get-InstalledScript -Name $testScriptName -ErrorAction SilentlyContinue
if ($installedScript) {
    Log-Output "Test script '$testScriptName' is installed and recognized."
} else {
    Log-Error "Test script '$testScriptName' is not installed. Please check the installation process."
}

# Validate the NuGet provider installation
Log-Output "Validating NuGet provider installation..."
try {
    $nugetProvider = Get-PackageProvider -Name NuGet -ErrorAction Stop
    Log-Output "NuGet provider is installed and recognized."
} catch {
    Log-Error "NuGet provider is not recognized. $_"
}

Log-Output "Preparation for PS Gallery installs completed successfully."
