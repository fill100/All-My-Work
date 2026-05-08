@echo off
:: 1. ตรวจสอบสิทธิ์ Admin และขอสิทธิ์ถ้ายังไม่ได้เป็น
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: 2. สร้างโฟลเดอร์เก็บ Script
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"

:: 3. สร้างไฟล์เรียก VPN ที่บังคับสิทธิ์ Admin
echo @echo off > C:\JVFS-IT\connect_vpn.bat
echo powershell -Command "Start-Process 'C:\Program Files\Fortinet\FortiClient\FortiClient.exe' -ArgumentList 'connect -h 119.110.207.194:20443' -Verb RunAs" >> C:\JVFS-IT\connect_vpn.bat

:: 4. ลงทะเบียน Protocol jvfs-connect://
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\" \"%%1\"" /f

echo ========================================
echo Setup Complete! 
echo Now you can use One-Click Connect from Web.
echo ========================================
pause