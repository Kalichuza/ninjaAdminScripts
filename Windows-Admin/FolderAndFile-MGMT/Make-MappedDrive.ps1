<#PSScriptInfo

.VERSION 1.2

.GUID 430e7dd5-05ae-4848-88b3-eb4260cb00b1

.AUTHOR Kalichuza

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Quick and dirty script to map a network drive 

.EXAMPLE
New-MappedDrive -FolderPath "\\Server\Share" -DriveLetter "Z" -Label "MyDrive" -Persist $true

#> 
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$FolderPath,  # The network share path (e.g., \\Server\Share)

    [Parameter(Mandatory)]
    [string]$DriveLetter,  # The drive letter to map the network share to

    [Parameter()]
    [string]$UserName,  # Optional username for the network share

    [Parameter()]
    [string]$Label,  # Optional label for the mapped drive

    [Parameter()]
    [switch]$Persist  # Optional flag to make the mapping persistent
)

function New-MappedDrive {
    param (
        [string]$DriveLetter,
        [string]$SharePath,
        [string]$UserName,
        [System.Security.SecureString]$Password,
        [string]$Label,
        [switch]$Persist
    )

    # Remove any existing mapping for the drive letter
    try {
        $output = cmd.exe /c "net use ${DriveLetter}: /delete /y" 2>&1
        if ($output -match "The network connection could not be found") {
            Write-Output "No existing mapping for drive $DriveLetter."
        }
    } catch {
        Write-Output "An error occurred while trying to remove existing mapping for drive $DriveLetter."
    }

    # Map the new network drive
    $persistentFlag = if ($Persist) { "/persistent:yes" } else { "/persistent:no" }
    if ($UserName -and $Password) {
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Write-Output "Mapping drive $DriveLetter to $SharePath with user $UserName..."
        cmd.exe /c "net use ${DriveLetter}: ${SharePath} /user:${UserName} ${plainPassword} $persistentFlag"
    } else {
        Write-Output "Mapping drive $DriveLetter to $SharePath..."
        cmd.exe /c "net use ${DriveLetter}: ${SharePath} $persistentFlag"
    }

    # Set the label for the mapped drive
    if ($Label) {
        Write-Output "Setting label for drive $DriveLetter to $Label..."
        cmd.exe /c "label ${DriveLetter}: $Label"
    }
}

# Prompt for password if UserName is provided
if ($UserName) {
    $Password = Read-Host -AsSecureString "Enter password for $UserName"
}

# Map the network share to a drive letter
New-MappedDrive -DriveLetter $DriveLetter -SharePath $FolderPath -UserName $UserName -Password $Password -Label $Label -Persist:$Persist