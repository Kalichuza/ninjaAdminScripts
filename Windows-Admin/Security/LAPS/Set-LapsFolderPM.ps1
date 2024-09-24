<#PSScriptInfo
.VERSION 1.0.1
.GUID 606b4f05-676e-4b93-8d0a-745e3a0c13d0
.AUTHOR Kalichuza
.DESCRIPTION
Sets correct folder permissions for LAPS GPO install

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

param(
    [Parameter(Mandatory = $true)]
    [string]$FolderPath
)

# Validate that the folder exists
if (-not (Test-Path -Path $FolderPath)) {
    Write-Error "The folder path '$FolderPath' does not exist."
    exit
}

# Get the current ACL
$acl = Get-Acl -Path $FolderPath

# Create a new access rule for 'Domain Computers' with Read and Execute permissions
$domainComputers = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Domain Computers",
    "ReadAndExecute",
    "ContainerInherit, ObjectInherit",
    "None",
    "Allow"
)

# Add the new rule to the ACL
$acl.AddAccessRule($domainComputers)

# Apply the updated ACL to the folder
Set-Acl -Path $FolderPath -AclObject $acl

# Display the updated ACL
Get-Acl -Path $FolderPath | Format-List
