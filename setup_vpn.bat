@echo off
chcp 65001 >nul
title JVFS VPN Final Fix for 7.2

:: 1. ขอสิทธิ์ Admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( goto UACPrompt ) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs" & exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%" & CD /D "%~dp0"

:: 2. ปิดโปรแกรมและล้าง Session ที่ค้างอยู่
echo กำลังล้างข้อมูลเก่า...
taskkill /f /im FortiClient.exe >nul 2>&1
taskkill /f /im FortiSSLVPNdaemon.exe >nul 2>&1

:: 3. เจาะ Registry ของ SSL-VPN โดยตรง (จุดที่ 7.2 มักจะอ่านค่า)
set REG_TUNNEL="HKCU\Software\Fortinet\FortiClient\Sslvpn\Tunnels\JVFS_VPN"
reg add %REG_TUNNEL% /v "Server" /t REG_SZ /d "119.110.207.194:20443" /f
reg add %REG_TUNNEL% /v "Description" /t REG_SZ /d "JVFS_VPN" /f
reg add %REG_TUNNEL% /v "promptuser" /t REG_DWORD /d 1 /f
reg add %REG_TUNNEL% /v "promptcertificate" /t REG_DWORD /d 0 /f

:: 4. สร้างไฟล์เรียกจากหน้าเว็บ (Protocol)
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"
echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

:: 5. บังคับเปิดโปรแกรมใหม่
echo กำลังเปิดโปรแกรม...
start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"

cls
echo ========================================
echo       [ แก้ไขค่า VPN สำเร็จแล้ว ]
echo ========================================
echo 1. หากหน้าจอยังขึ้น "Configure VPN" 
echo    ให้ลองคลิกที่ไอคอน "ฟันเฟือง" (Settings) 
echo    แล้วกดย้อนกลับมาหน้าหลัก 1 ครั้ง
echo 2. หรือลองกดปุ่ม One-Click จากหน้าเว็บอีกรอบ
echo ========================================
pause