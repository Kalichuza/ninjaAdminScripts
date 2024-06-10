# Define variables
$domainName = "YourDomainName"
$domainAdminUser = "YourDomainAdminUser"
$domainAdminPassword = "YourDomainAdminPassword"
$safeModePassword = "YourNewSafeModeAdministratorPassword"
$siteName = "YourSiteName"

# Install AD DS Role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import ADDSDeployment Module
Import-Module ADDSDeployment

# Prompt for domain admin credentials
$securePassword = ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($domainAdminUser, $securePassword)

# Promote the server to a domain controller
Install-ADDSDomainController `
    -DomainName $domainName `
    -InstallDns `
    -Credential $credential `
    -SiteName $siteName `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword (ConvertTo-SecureString $safeModePassword -AsPlainText -Force) `
    -NoRebootOnCompletion `
    -Force

# Restart the server
Restart-Computer
