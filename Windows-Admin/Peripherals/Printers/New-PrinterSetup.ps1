$printer = "\\Path\To\Printer"

Add-Printer -ConnectionName $printer

$set2default = "True"

if ($set2default -eq "True") {
    $wsObject = New-Object -ComObject WScript.Network
    $wsObject.SetDefaultPrinter($printer)

    $default =(Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Default = TRUE").Name

    Write-Host "Set $default as default printer"
} else {
    Write-Host "Added $printer"
}

