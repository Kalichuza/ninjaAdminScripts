# E.G. New-ADUserHomeFolders -BaseFolderPath "D:\HomeDrives" -DaysAgo 30 -SearchBase "OU=Users,DC=domain,DC=local"

Function New-ADUserHomeFolders {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$BaseFolderPath,           # The parent directory (e.g., D:\Company\HomeDrives)

        [Parameter(Mandatory)]
        [int]$DaysAgo,                    # The number of days in the past to filter users by (e.g., 30 for last 30 days)

        [Parameter(Mandatory)]
        [string]$SearchBase               # The AD OU to search in (e.g., "OU=Users,OU=MyBusiness,DC=nppd,DC=local")
    )

    # Define the cutoff date
    $CutoffDate = (Get-Date).AddDays(-$DaysAgo)

    # Get all users from AD who logged in within the specified timeframe
    $Users = Get-ADUser -Filter * -SearchBase $SearchBase -Properties LastLogonTimestamp |
        Where-Object {
            $_.LastLogonTimestamp -and 
            ([DateTime]::FromFileTime($_.LastLogonTimestamp) -ge $CutoffDate)
        }

    Write-Host "Found $($Users.Count) users who logged in within the last $DaysAgo days" -ForegroundColor Green

    foreach ($User in $Users) {
        $Username = $User.SamAccountName
        $UserFolderPath = Join-Path -Path $BaseFolderPath -ChildPath $Username

        # Check if the folder already exists
        if (-not (Test-Path $UserFolderPath)) {
            Write-Host "Creating folder for $Username at $UserFolderPath" -ForegroundColor Cyan
            New-Item -ItemType Directory -Path $UserFolderPath | Out-Null
        } else {
            Write-Host "Folder already exists for $Username at $UserFolderPath" -ForegroundColor Yellow
        }

        # Fix Permissions
        try {
            # Get ACL for the folder
            $Acl = Get-Acl $UserFolderPath

            # Disable inheritance and remove inherited rules
            $Acl.SetAccessRuleProtection($true, $false) # Disable inheritance, remove inherited rules
            $Acl.Access | ForEach-Object { $Acl.RemoveAccessRule($_) }

            # Add FullControl for the specific user
            $UserAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                "$Username", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
            )
            $Acl.AddAccessRule($UserAccessRule)

            # Add FullControl for SYSTEM
            $SystemAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                "SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
            )
            $Acl.AddAccessRule($SystemAccessRule)

            # Apply the ACL to the folder
            Set-Acl -Path $UserFolderPath -AclObject $Acl
            Write-Host "Set permissions for $Username: Folder at $UserFolderPath" -ForegroundColor Green
        } catch {
            Write-Error "Failed to set permissions for $UserFolderPath. Error: $_"
        }
    }
}
