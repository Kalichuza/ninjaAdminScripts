Import-Module ActiveDirectory

# Define the time span for inactivity
$daysInactive = $env:numberOfDaysInactive
$timeLimit = (Get-Date).AddDays(-$daysInactive)

# Get all AD user accounts that have been inactive longer than the time limit
$inactiveUsers = Get-ADUser -Filter 'Enabled -eq $true -and LastLogonDate -lt $timeLimit' -Properties LastLogonDate, samAccountName | where { $_.Enabled -eq $true }

# Define the path to the output file in the temporary folder
$outputFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "InactiveUsers.txt")

# Output the inactive users' usernames to the console and the text file
if($inactiveUsers.Count -gt 0) {
    $output = "Found $($inactiveUsers.Count) inactive users:`n" + ($inactiveUsers | Select-Object -ExpandProperty samAccountName | Out-String)
    Write-Host $output
    $output | Out-File -FilePath $outputFile
} else {
    Write-Host "No inactive users found."
    "No inactive users found." | Out-File -FilePath $outputFile
}

# Inform the user about the location of the output file
Write-Host "Inactive user list saved to $outputFile"
