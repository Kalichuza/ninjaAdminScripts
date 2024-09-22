# Get all computers in the domain
$computers = Get-ADComputer -Filter * -Property ms-Mcs-AdmPwd

# Filter out computers that do not have the ms-Mcs-AdmPwd attribute set
$computersWithoutAdmPwd = $computers | Where-Object { -not $_."ms-Mcs-AdmPwd" }

# Output the list of computers
$computersWithoutAdmPwd | Select-Object Name, DistinguishedName
