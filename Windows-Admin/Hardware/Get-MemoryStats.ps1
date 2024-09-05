# This script was slightly modified from the original script by technet. Link below to the original script
# https://gallery.technet.microsoft.com/scriptcenter/Get-Memory-RAM-configuratio-35dda12e#:~:text=PowerShell%20-%20Get%20Memory%20%28RAM%29%20configuration%20for%20local,number%20of%20used%20slots.Use%20-Computername%20to%20specify%20the

$Computername = $Env:COMPUTERNAME
$PhysicalMemory = Get-WmiObject -class "win32_physicalmemory" -namespace "root\CIMV2" -ComputerName $Computername 
 
Write-Host "Memore Modules:" -ForegroundColor Green 
$PhysicalMemory | Format-Table Tag,BankLabel,@{n="Capacity(GB)";e={$_.Capacity/1GB}},Manufacturer,PartNumber,Speed -AutoSize 
 
Write-Host "Total Memory:" -ForegroundColor Green 
Write-Host "$((($PhysicalMemory).Capacity | Measure-Object -Sum).Sum/1GB)GB" 
 
$TotalSlots = ((Get-WmiObject -Class "win32_PhysicalMemoryArray" -namespace "root\CIMV2" -ComputerName $Computername).MemoryDevices | Measure-Object -Sum).Sum 
Write-Host "`nTotal Memory Slots:" -ForegroundColor Green 
Write-Host $TotalSlots 
 
$UsedSlots = (($PhysicalMemory) | Measure-Object).Count  
Write-Host "`nUsed Memory Slots:" -ForegroundColor Green 
Write-Host $UsedSlots 
 
If($UsedSlots -eq $TotalSlots) 
{ 
    Write-Host "`nAll memory slots are filled up, none is empty!" -ForegroundColor Yellow 
}
