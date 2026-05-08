@echo off
chcp 65001 >nul
:: 1. ตรวจสอบสิทธิ์ Admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( goto UACPrompt ) else ( goto gotAdmin )

:UACPrompt
    echo Requesting Admin...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: 2. แก้ปัญหา Windows ไม่รู้จักไฟล์ .vpl (บังคับให้ใช้ FortiClient เปิด)
assoc .vpl=FortiClient.VPL
ftype FortiClient.VPL="C:\Program Files\Fortinet\FortiClient\FortiClient.exe" "%%1"

:: 3. สร้างโฟลเดอร์และไฟล์ Config
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"
set CONF_FILE=C:\JVFS-IT\jvfs_setup.vpl

echo [VPN_PROFILE]> %CONF_FILE%
echo name=JVFS_VPN>> %CONF_FILE%
echo server=119.110.207.194:20443>> %CONF_FILE%
echo type=sslvpn>> %CONF_FILE%

:: 4. สั่งเปิดไฟล์ Config (รอบนี้ต้องไม่เด้งถามแบบเดิมแล้ว)
start "" "%CONF_FILE%"

:: 5. ตั้งค่า Protocol สำหรับเรียกจากหน้าเว็บ
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\Fortinet\FortiClient\FortiClient.exe\"" /f

cls
echo ========================================
echo        [ แก้ไขการเชื่อมโยงไฟล์แล้ว ]
echo ========================================
echo 1. หน้าจอ "How do you want to open this file?" จะไม่ขึ้นแล้ว
echo 2. จะมีหน้าต่าง FortiClient เด้งมาให้กด "Yes" เพื่อยืนยันการตั้งค่า
echo 3. ถ้ากด Yes แล้ว ชื่อ JVFS_VPN จะโผล่ในโปรแกรมทันทีครับ
echo ========================================
pause
