
<#PSScriptInfo

.VERSION 1.0

.GUID 523e824c-ca14-4bd9-a646-d15ccc967be9

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
 Returns a formatted version of the SECEDIT permissions file. 

#> 
param (
    [switch]$OutputToFile,  # Option to output to a file
    [string]$OutputFilePath = "$Env:TEMP\UserPermissionsOutput.txt"  # Default output file path
)

# Well-known SIDs mapping
$wellKnownSIDs = @{
    "S-1-1-0" = "Everyone"
    "S-1-5-32-544" = "Administrators"
    "S-1-5-32-545" = "Users"
    "S-1-5-32-551" = "Backup Operators"
    "S-1-5-19" = "NT AUTHORITY\LOCAL SERVICE"
    "S-1-5-20" = "NT AUTHORITY\NETWORK SERVICE"
    "S-1-5-6" = "SERVICE"
    "S-1-5-90-0" = "Windows Manager\Windows Manager Group"
    "S-1-5-83-0" = "NT VIRTUAL MACHINE\Virtual Machines"
    "S-1-5-32-555" = "Remote Desktop Users"
}

# Export local and merged policy to temporary files
C:\Windows\System32\SecEdit.exe /export /areas USER_RIGHTS /cfg $Env:TEMP\LocalSecEdit.txt    
C:\Windows\System32\SecEdit.exe /export /mergedpolicy /areas USER_RIGHTS /cfg $Env:TEMP\MergedSecEdit.txt

# Read the output of the SecEdit export
$localOut = Get-Content -Path $Env:TEMP\LocalSecEdit.txt
$mergedOut = Get-Content -Path $Env:TEMP\MergedSecEdit.txt

# Get all user accounts on the computer, including domain users
$users = Get-CimInstance -ClassName Win32_UserAccount

# Create a hashtable to map SIDs to usernames
$sidToUser = @{}
foreach ($user in $users) {
    $sidToUser[$user.SID] = $user.Name
}

# Add well-known SIDs to the hashtable
foreach ($sid in $wellKnownSIDs.Keys) {
    if (-not $sidToUser.ContainsKey($sid)) {
        $sidToUser[$sid] = $wellKnownSIDs[$sid]
    }
}

# Function to replace SIDs with usernames in the SecEdit output
function Replace-SidWithUsername {
    param (
        [string[]]$inputLines,
        [hashtable]$sidMap
    )

    $outputObjects = foreach ($line in $inputLines) {
        if ($line -match "^(.*?)=(.*)$") {
            $right = $matches[1].Trim().Trim('=')
            $sids = $matches[2].Split(',').Trim('*')
            $userNames = $sids | ForEach-Object { 
                if ($sidMap.ContainsKey($_)) { 
                    $sidMap[$_] 
                } else { 
                    $_  # Include the SID if there's no name found
                } 
            }

            # Return only the right name in the Name property and all user names/SIDs in the UserId property
            [PSCustomObject]@{
                Name   = $right
                UserId = '{ ' + ($userNames -join ', ') + ' }'
            }
        }
    }
    return $outputObjects
}

# Replace SIDs with usernames in the output
$localOutWithUsernames = Replace-SidWithUsername -inputLines $localOut -sidMap $sidToUser
$mergedOutWithUsernames = Replace-SidWithUsername -inputLines $mergedOut -sidMap $sidToUser

# Display or save the output
if ($OutputToFile) {
    $localOutWithUsernames | Out-File -FilePath $OutputFilePath -Encoding UTF8
    $mergedOutWithUsernames | Out-File -FilePath $OutputFilePath -Append -Encoding UTF8
    Write-Output "Output written to $OutputFilePath"
} else {
    $localOutWithUsernames + $mergedOutWithUsernames | ForEach-Object { Write-Output $_ }
}

# Delete the temporary files
Remove-Item -Path $Env:TEMP\LocalSecEdit.txt -ErrorAction SilentlyContinue
Remove-Item -Path $Env:TEMP\MergedSecEdit.txt -ErrorAction SilentlyContinue


