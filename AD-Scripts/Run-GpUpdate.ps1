$AdComputers = Get-ADComputer -Filter "*"
$ComputerNames = $AdComputers | select -ExpandProperty "Name"


try {
    foreach ($name in $ComputerNames) {
        Invoke-Command -ScriptBlock { gpupdate /force } -ComputerName $name 
        Write-host "$($name) is updating..."
    }
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host "The task could not be completed."
}