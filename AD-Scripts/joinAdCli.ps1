param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,

    [Parameter(Mandatory=$true)]
    [string]$DomainUser,

    [Parameter(Mandatory=$false)]
    [string]$NewComputerName
)

# Prompt for the domain password securely
$DomainPassword = Read-Host -AsSecureString -Prompt "Enter domain password"

# Create PSCredential object
$credential = New-Object System.Management.Automation.PSCredential ($DomainUser, $DomainPassword)

# Rename the computer (if a new computer name is provided)
if ($NewComputerName -ne "") {
    Rename-Computer -NewName $NewComputerName -Force -Restart
    Start-Sleep -Seconds 60 # Give the computer time to restart
}

# Join the computer to the domain
Add-Computer -DomainName $DomainName -Credential $credential -Restart

# Output result
if ($LASTEXITCODE -eq 0) {
    Write-Output "Computer successfully joined to the domain $DomainName."
} else {
    Write-Error "Failed to join the computer to the domain $DomainName."
}
