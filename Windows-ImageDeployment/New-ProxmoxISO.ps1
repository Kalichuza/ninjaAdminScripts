<#
After much trial and error, the most effective method I have found to provision an ISO for Proxmox is via a the following command. 
This should be run using a premade usbe that has a WinPE drive and all of the needed provisioning files correctly formatted.
#>



cd "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"

.\oscdimg.exe -b"F:\Boot\etfsboot.com" -u2 -h -m -o "F:\" "C:\CustomISO\Windows.iso"