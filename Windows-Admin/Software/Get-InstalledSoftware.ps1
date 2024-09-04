[CmdletBinding()]
param (
    [switch]$ExportToCSV,
    [string]$CSVFilePath = "C:\InstalledApplications.csv"
)

# Get Traditional Installed Software (MSI/EXE)
$traditionalApps = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
                   Select-Object @{Name="ApplicationType";Expression={"Traditional"}}, DisplayName, DisplayVersion, InstallDate

# Get 32-bit Installed Software on 64-bit systems
$wow64Apps = Get-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" |
             Select-Object @{Name="ApplicationType";Expression={"Traditional (32-bit)"}}, DisplayName, DisplayVersion, InstallDate

# Get UWP (Microsoft Store) Apps
$uwpApps = Get-AppxPackage | 
           Select-Object @{Name="ApplicationType";Expression={"UWP (Microsoft Store)"}}, Name, @{Name="DisplayVersion";Expression={$_.Version}}, @{Name="InstallDate";Expression={"N/A"}}

# Combine all applications
$allApps = $traditionalApps + $wow64Apps + $uwpApps

# Output the results as objects
$allApps

# Optional: Export to CSV if specified
if ($ExportToCSV) {
    $allApps | Export-Csv -Path $CSVFilePath -NoTypeInformation
    Write-Host "Installed applications list exported to $CSVFilePath"
}
