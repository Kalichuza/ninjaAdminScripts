1. Upload the script to the target machine.
 
2. Set up Mapped Drive to your target folder.
	net use J: \\SERVER\Pathe\To\NetDrive /user:domain\administrator P4ssWord

3. Use this command to initiate the transfer:

	.\moveFolder2NetDrive.ps1 -source "C:\Path\To\Origin" -destination "J:" -username "domain\administrator" -password 'PassWord'




C:\Users\KGray


net use P: \\SAUGFSK\Gray /user:townhall\administrator Saugadmin1

.\moveFolder2NetDrive.ps1 -source "C:\Users\" -destination "P:" -username "townhall\administrator" -password ''
