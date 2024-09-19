
<#PSScriptInfo

.VERSION 1.3

.GUID fb20ee30-220f-49e9-af0a-fb7c6ae764c7

.AUTHOR Kevin

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
Downloads a script from a remotely hosted source like Github or pastebin. Really, anywhere that you can host raw text code.

#> 

# Flags
param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptUrl,

    [Parameter(Mandatory=$true)]
    [string]$OutFile
)

# Downloads remotely hosted code and saves it as an outfile of choosing
Invoke-WebRequest -Uri $ScriptUrl -OutFile $OutFile -UseBasicParsing
