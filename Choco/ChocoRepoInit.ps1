param(
    [string]$SharePath = "C:\ChocoRepo",
    [string]$ShareName = "ChocoRepo",
    [string]$Description = "Chocolatey Repository Share"
)

# Create the repository folder if it doesn't exist
if (-Not (Test-Path $SharePath)) {
    New-Item -Path $SharePath -ItemType Directory
}

# Set ACLs for security: Read & Execute for everyone, full control for admins
$acl = Get-Acl $SharePath
$everyone = New-Object System.Security.Principal.NTAccount("Everyone")
$admin = "Administrators"
$rights = [System.Security.AccessControl.FileSystemRights]::ReadAndExecute
$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$propagation = [System.Security.AccessControl.PropagationFlags]::None
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($everyone, $rights, $inheritance, $propagation, [System.Security.AccessControl.AccessControlType]::Allow)
$acl.SetAccessRule($accessRule)

# Administrators get full control
$adminRights = [System.Security.AccessControl.FileSystemRights]::FullControl
$adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule($admin, $adminRights, $inheritance, $propagation, [System.Security.AccessControl.AccessControlType]::Allow)
$acl.AddAccessRule($adminRule)
Set-Acl -Path $SharePath -AclObject $acl

# Create the SMB share with the appropriate permissions
$SMBShareParams = @{
    Name = $ShareName
    Path = $SharePath
    Description = $Description
    FullAccess = $admin
    ReadAccess = "Everyone"
}

# Check if the share already exists to avoid duplication
if (-Not (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
    New-SmbShare @SMBShareParams
    Write-Host "SMB Share $ShareName created successfully at $SharePath"
} else {
    Write-Host "The share $ShareName already exists."
}
