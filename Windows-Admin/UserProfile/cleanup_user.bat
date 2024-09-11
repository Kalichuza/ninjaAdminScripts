@echo off
echo Cleaning up user profile and system...

:: Get the current user's profile path
set userprofile=%USERPROFILE%

:: Clear User Temp Folder
echo Deleting files in %userprofile%\AppData\Local\Temp
del /s /f /q "%userprofile%\AppData\Local\Temp\*"
rd /s /q "%userprofile%\AppData\Local\Temp\"

:: Clear Windows Temp Folder
echo Deleting files in C:\Windows\Temp
del /s /f /q "C:\Windows\Temp\*"
rd /s /q "C:\Windows\Temp\"

:: Clear Chrome Cache
if exist "%userprofile%\AppData\Local\Google\Chrome\User Data\Default\Cache\" (
    echo Deleting Chrome Cache...
    del /s /f /q "%userprofile%\AppData\Local\Google\Chrome\User Data\Default\Cache\*"
)

:: Clear Edge Cache
if exist "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\" (
    echo Deleting Edge Cache...
    del /s /f /q "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*"
)

:: Clear Downloads Folder
:: echo Deleting files in Downloads folder...
:: del /s /f /q "%userprofile%\Downloads\*"

:: Clear Recycle Bin
echo Emptying Recycle Bin...
rd /s /q %userprofile%\$Recycle.Bin

:: Clear Windows Error Reporting Files
echo Deleting Windows Error Reporting Files...
del /s /f /q "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*"

:: Clear Windows Update Cache
echo Deleting Windows Update Cache...
net stop wuauserv
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*"
net start wuauserv

:: Clear Prefetch Data
echo Deleting Prefetch Data...
del /s /f /q "C:\Windows\Prefetch\*"

:: Optional: Turn off hibernation (uncomment if needed)
:: echo Turning off Hibernation...
:: powercfg -h off

echo Cleanup complete!
pause
