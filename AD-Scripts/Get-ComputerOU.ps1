<#PSScriptInfo

.VERSION 1.0

.GUID 9ae3fbcd-594a-46ce-904a-842c05b56e4c

.AUTHOR Kalichuza

#>

<# 

.DESCRIPTION 
This will check AD for OUs containing domain computers. 
#>

# Ensure the Active Directory module is loaded
Import-Module ActiveDirectory

# Retrieve all Organizational Units in the domain
$allOUs = Get-ADOrganizationalUnit -Filter *

# Create an empty array to store OUs that contain computers
$ousWithComputers = @()

# Loop through each OU to check if it contains any computers
foreach ($ou in $allOUs) {
    # Search for computers within the current OU
    $computersInOU = Get-ADComputer -Filter * -SearchBase $ou.DistinguishedName -ErrorAction SilentlyContinue
    
    if ($computersInOU) {
        # If computers are found, add the OU to the list
        $ousWithComputers += $ou
    }
}

# Display the OUs that contain computers
$ousWithComputers | ForEach-Object {
    [PSCustomObject]@{
        OrganizationalUnit = $_.DistinguishedName
        NumberOfComputers  = (Get-ADComputer -Filter * -SearchBase $_.DistinguishedName).Count
    }
}

