@echo off
chcp 65001 >nul
title JVFS VPN One-Click Setup

:: 1. ตรวจสอบสิทธิ์ Admin (ถ้าไม่ใช่ให้ขอสิทธิ์)
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo กำลังขอสิทธิ์ผู้ดูแลระบบ (Admin)...
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

:: 2. ปิด FortiClient เพื่อเตรียมล้าง Config เก่า
echo กำลังเตรียมการติดตั้ง...
taskkill /f /im FortiClient.exe >nul 2>&1

:: 3. สร้างไฟล์ XML Config สำหรับ FortiClient 7.x+
:: โดยวางไว้ที่ AppData/Local ตามที่ Log ของคุณแจ้งไว้
set CONFIG_DIR=%LocalAppData%\Fortinet\FortiClient\config
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

set XML_FILE=%CONFIG_DIR%\vpn_profiles.xml

echo ^<vpn_profiles^> > "%XML_FILE%"
echo   ^<profile^> >> "%XML_FILE%"
echo     ^<name^>JVFS_VPN^</name^> >> "%XML_FILE%"
echo     ^<type^>ssl^</type^> >> "%XML_FILE%"
echo     ^<server^>119.110.207.194:20443^</server^> >> "%XML_FILE%"
echo     ^<allow_invalid_server_cert^>1^</allow_invalid_server_cert^> >> "%XML_FILE%"
echo   ^</profile^> >> "%XML_FILE%"
echo ^</vpn_profiles^> >> "%XML_FILE%"

:: 4. สร้างไฟล์ Batch สำหรับเรียกใช้งานผ่าน Web (One-Click)
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"
echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

:: 5. ลงทะเบียน Protocol jvfs-connect:// ใน Registry
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

:: 6. แจ้งเตือนเมื่อเสร็จสิ้น
cls
echo =======================================================
echo          ติดตั้งระบบ JVFS One-Click สำเร็จ!
echo =======================================================
echo.
echo  1. ตอนนี้โปรไฟล์ "JVFS_VPN" ถูกติดตั้งลงในเครื่องแล้ว
echo  2. คุณสามารถกดปุ่ม "🚀 ONE-CLICK CONNECT" บนหน้าเว็บได้ทันที
echo  3. หากโปรแกรมถามหา Password ให้ระบุรหัสผ่านของคุณเพื่อเชื่อมต่อ
echo.
echo =======================================================
echo กดปุ่มใดก็ได้เพื่อปิดหน้าต่างนี้...
pause >nul
