# Flags 
param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptUrl,

    [Parameter(Mandatory=$true)]
    [string]$FileName
)

#Downloads remotely hosted code and saves it as an outfile of choosing
Invoke-WebRequest -Uri $ScriptUrl -OutFile "C:\$($FileName)"
