Set-ExecutionPolicy RemoteSigned -Force
 
Install-Module OSD -Force
 
Import-Module OSD -Force
 
New-OSDCloudTemplate
 
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
 
New-OSDCloudUSB
 
Edit-OSDCloudwinPE -workspacepath C:\OSDCloud -CloudDriver * -WebPSScript https://raw.githubusercontent.com/Kalichuza/ninjaAdminScripts/main/Windows-ImageDeployment/Dynamic-Deploy.ps1 -Verbose
 
New-OSDCloudISO
 
Update-OSDCloudUSB