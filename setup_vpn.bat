@echo off
chcp 65001 >nul
title JVFS VPN One-Click Setup

:: 1. ตรวจสอบสิทธิ์ Admin
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

:: 2. ปิด FortiClient ให้สนิทก่อน (ถ้าเปิดค้างอยู่ มันจะไม่โหลด Config ใหม่)
echo กำลังล้างการตั้งค่าเดิม...
taskkill /f /im FortiClient.exe >nul 2>&1

:: 3. สร้างไฟล์ Config ยัดลงไปทุก Path ที่ FortiClient 7.2+ ใช้งาน
:: Path A: Local AppData (สำหรับเครื่องทั่วไป)
set LOCAL_CONFIG="%LocalAppData%\Fortinet\FortiClient\config"
if not exist %LOCAL_CONFIG% mkdir %LOCAL_CONFIG%

:: Path B: Roaming AppData (สำหรับบางระบบ)
set ROAM_CONFIG="%AppData%\Fortinet\FortiClient\config"
if not exist %ROAM_CONFIG% mkdir %ROAM_CONFIG%

:: ฟังก์ชันเขียนไฟล์ XML
set XML_CONTENT=^<vpn_profiles^>^<profile^>^<name^>JVFS_VPN^</name^>^<type^>ssl^</type^>^<server^>119.110.207.194:20443^</server^>^<allow_invalid_server_cert^>1^</allow_invalid_server_cert^>^</profile^>^</vpn_profiles^>

echo %XML_CONTENT% > %LOCAL_CONFIG%\vpn_profiles.xml
echo %XML_CONTENT% > %ROAM_CONFIG%\vpn_profiles.xml

:: 4. สร้างตัวเรียกจากเว็บ (jvfs-connect://)
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"
echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

:: ลงทะเบียน Protocol ใน Registry
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

:: 5. เปิดโปรแกรมขึ้นมาใหม่ทันที
start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"

cls
echo =======================================================
echo          [ ติดตั้ง JVFS VPN สำเร็จแล้ว! ]
echo =======================================================
echo.
echo  ตอนนี้ในโปรแกรม FortiClient จะต้องมีชื่อ "JVFS_VPN" ขึ้นมาแล้ว
echo  ถ้ายังขึ้น Configure VPN ให้ลองปิดโปรแกรมแล้วเปิดใหม่
echo.
echo  หลังจากนี้ คุณสามารถใช้ปุ่มบนหน้าเว็บเพื่อเปิดโปรแกรมได้เลย
echo =======================================================
echo กดปุ่มใดก็ได้เพื่อจบการทำงาน...
pause >nul