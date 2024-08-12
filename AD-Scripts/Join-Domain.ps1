[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$user,

    [Parameter(Mandatory)]
    [string]$domain,

    [Parameter(Mandatory)]
    [string]$pass = (Read-Host -Prompt 'Enter Pass: ' -AsSecureString)
)

function Join-Domain {
    $username = "$domain\$user"
    $password = $pass
    $securePassword = $password | ConvertTo-SecureString

    $credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

    try {
        Add-Computer -DomainName $domain -Credential $credential -ErrorAction Stop
        Write-Host "Successfully joined the domain $domain." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to join the domain. Error: $_" -ForegroundColor Red
        return
    }

    $response = Read-Host "Would you like to restart now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') {
        Restart-Computer
    }
    else {
        Write-Host "Please restart the computer manually to complete the domain join process." -ForegroundColor Yellow
    }
}

Join-Domain
