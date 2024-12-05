
<#PSScriptInfo

.VERSION 1.2

.GUID 939c17ef-26bb-43c0-b23e-a4818fbefb15

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

#>

<# 

.DESCRIPTION 
This script continuously sends requests to random hostnames from a provided list. If a spoofed response is detected,
it logs the event, including the attacker's IP address, hostname, and a custom message, to a CSV file.
#> 
<#
.SYNOPSIS
    Detects potential LLMNR/NBT-NS poisoning by sending requests to specified hostnames and logging any spoofing responses.

.DESCRIPTION
    This script continuously sends requests to random hostnames from a provided list. If a spoofed response is detected,
    it logs the event, including the attacker's IP address, hostname, and a custom message, to a CSV file.

.PARAMETER LogFile
    The name or path of the CSV file where the results will be saved.

.PARAMETER HostTable
    A hashtable of false hostnames to request during each iteration of the script.

.EXAMPLE
    .\Detect-WindowsPoiseners.ps1 -LogFile "C:\Logs\results.csv" -HostTable @{'TX-Host' = 'CORP-TX-FILE-01'; 'NY-Host' = 'COPY-NY-DC-02'}

    This command will send requests to the specified hostnames and log the results in C:\Logs\results.csv.

.EXAMPLE
    .\Detect-WindowsPoiseners.ps1 -LogFile ".\tmppoisoning.csv" -HostTable @{'Host1' = 'FAKE-HOST-01'; 'Host2' = 'FAKE-HOST-02'}

    This example logs requests and their outcomes to the specified tmppoisoning.csv file.


#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="The CSV file where results will be saved.")]
    [string]$LogFile,

    [Parameter(Mandatory=$true, HelpMessage="A hashtable of hostnames to request.")]
    [hashtable]$HostTable
)

# Set the interval and jitter for random sleep times between requests
$interval = 30 #The minimum number of seconds to wait between requests
$jitter = 30   #The maximum value for a random number of seconds to add to the interval

while ($true) {
    Start-Sleep -Seconds ($interval + (Get-Random -Maximum ($jitter + 1)))
    try {
        $ErrorActionPreference = 'Stop'
        
        # Select a random hostname from the provided hashtable
        $request = Get-Random -InputObject $HostTable.Values
        
        # Attempt to resolve the hostname
        $resolvedAddresses = (Resolve-DnsName -LlmnrNetbiosOnly -Name $request).IPAddress

        # Select the first IP if multiple are found, or handle no results
        if ($resolvedAddresses -is [array]) {
            $ipAddr = $resolvedAddresses[0].ToString()
        } elseif ($resolvedAddresses) {
            $ipAddr = $resolvedAddresses.ToString()
        } else {
            $ipAddr = 'Not Found'
        }

        $ErrorActionPreference = "Continue"
        
        # Create the event object
        $event = [pscustomobject]@{
            date        = Get-Date -Format o
            host        = $env:COMPUTERNAME
            request     = $request
            attacker_ip = $ipAddr
            message     = "LLMNR/NBT-NS spoofing by $ipAddr detected with $request request"
        }

        Write-Output $event.message

        # Append the event to the specified CSV log file
        $event | Export-Csv -Path $LogFile -Append -NoTypeInformation
    } catch {
        # Suppress output for specific errors like timeout
    } finally {
        $ErrorActionPreference = "Continue"
    }
}
