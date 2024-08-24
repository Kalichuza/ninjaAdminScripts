@echo off

REM Set the path to dcu-cli.exe
SET DCU_CLI="C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"

REM Check if the path exists
IF NOT EXIST %DCU_CLI% (
    echo "Error: %DCU_CLI% not found."
    exit /b 1
)

REM Set the path to the log directory
SET LOG_DIR="C:\Logs\DellCommandUpdate"

REM Create the log directory if it doesn't exist
IF NOT EXIST %LOG_DIR% (
    mkdir %LOG_DIR%
)

REM Run Dell Command Update silently with logging enabled
%DCU_CLI% /applyUpdates -outputLog="%LOG_DIR%\DellCommandUpdate.log" -silent -reboot=enable

REM Check the exit code
IF %ERRORLEVEL% EQU 2 (
    echo Reboot required. Restarting now...
    shutdown /r /t 0
) ELSE IF %ERRORLEVEL% EQU 3010 (
    echo Reboot required. Restarting now...
    shutdown /r /t 0
) ELSE (
    echo No reboot required.
)

exit /b %ERRORLEVEL%
