netsh advfirewall firewall set rule group="remote desktop" new enable=Yes
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
net stop UmRdpService
net stop TermService
net start TermService
