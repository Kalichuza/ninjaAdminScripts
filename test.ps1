param (
    [Parameter(Mandatory=$false)]
    [switch]$Flag1 = $false,

    [Parameter(Mandatory=$false)]
    [switch]$Flag2 = $false,

    [Parameter(Mandatory=$false)]
    [switch]$Flag3 = $false,

    [Parameter(Mandatory=$false)]
    [string]$SomeOtherArg
)

if ($Flag1) {
    Write-Output "Flag1 is set."
} else {
    Write-Output "Flag1 is not set."
}

if ($Flag2) {
    Write-Output "Flag2 is set."
} else {
    Write-Output "Flag2 is not set."
}

if ($Flag3) {
    Write-Output "Flag3 is set."
} else {
    Write-Output "Flag3 is not set."
}

if ($SomeOtherArg) {
    Write-Output "SomeOtherArg: $SomeOtherArg"
} else {
    Write-Output "SomeOtherArg is not set."
}
