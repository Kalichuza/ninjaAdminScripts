
<#PSScriptInfo

.VERSION 1.0.1

.GUID c4673250-7a87-472a-a646-d89266f568cb

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


.DESCRIPTION 
 Sets correct folder permissions for PWSH transcript GPO 

#> 


param (
    [Parameter(Mandatory = $true)]
    [string]$FolderPath
)

function Set-PwshFolderPermissions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FolderPath
    )

    # Validate that the folder exists
    if (-not (Test-Path -Path $FolderPath)) {
        Write-Error "The folder path '$FolderPath' does not exist."
        return
    }

    try {
        # Get the current ACL
        $acl = Get-Acl -Path $FolderPath

        # Define the necessary FileSystemRights for writing transcripts
        $rights = [System.Security.AccessControl.FileSystemRights]::Write

        # Define the access rule for 'Domain Computers' with minimal write permissions
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Domain Computers",
            $rights,
            "ContainerInherit, ObjectInherit",
            "None",
            "Allow"
        )

        # Add the new access rule
        $acl.SetAccessRule($accessRule)

        # Apply the updated ACL to the folder
        Set-Acl -Path $FolderPath -AclObject $acl

        Write-Host "Permissions successfully updated for '$FolderPath'."
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Call the function and pass the folder path
Set-PwshFolderPermissions -FolderPath $FolderPath

