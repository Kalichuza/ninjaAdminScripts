Set-ExecutionPolicy RemoteSigned -Force
 
Install-Module OSD -Force
 
Import-Module OSD -Force
 
New-OSDCloudTemplate
 
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
 
New-OSDCloudUSB
 
Edit-OSDCloudwinPE -workspacepath C:\OSDCloud -CloudDriver * -WebPSScript https://gist.githubusercontent.com/Jeffhunter88/ed338a1c3aab4ca6abd2dd68a329d53c/raw/osdcloud_config.ps1 -Verbose
 
New-OSDCloudISO
 
Update-OSDCloudUSB