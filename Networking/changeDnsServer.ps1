#This version of the code is optimized to run in NinjaOne's scripting engine.
# Define the new DNS server addresses
$dnsServers = $env:domainControllerIpAddress, $env:secondaryDnsServer

# Get the active network adapter
$activeInterface = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

if ($activeInterface) {
    # Set the DNS server addresses for the active network interface
    $interfaceName = $activeInterface.Name
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses $dnsServers

    # Display the updated DNS server settings
    Get-DnsClientServerAddress
} else {
    Write-Host "No active network interface found."
}
