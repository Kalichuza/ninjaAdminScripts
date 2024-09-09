
<#PSScriptInfo

.VERSION 1.0.2

.GUID 67a843be-0b8b-41d7-8586-c5dc3a0656fa

.AUTHOR kc

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
Run Remote Script in memory with parameters.

#> 


param (
    [Parameter(Mandatory = $true)]
    [string]$ScriptUrl,  # URL of the remote script

    [Parameter(Mandatory = $true)]
    [hashtable]$Parameters  # Hashtable of parameters
)

try {
    Write-Output "Fetching script from $ScriptUrl"
    
    # Fetch the script content from the provided URL
    $scriptContent = (Invoke-WebRequest -Uri $ScriptUrl -UseBasicParsing).Content
    Write-Output "Fetched script content."

    # Create a script block from the fetched content
    $scriptBlock = [ScriptBlock]::Create($scriptContent)

    # Prepare the arguments for the remote script
    $argList = @()
    foreach ($key in $Parameters.Keys) {
        $argList += $Parameters[$key]  # Only pass values (not key=value)
    }

    Write-Output "Executing the script with parameters: $($Parameters.Keys)"
    Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $argList

    Write-Output "Script executed successfully."
}
catch {
    Write-Error "An error occurred: $_"
}
