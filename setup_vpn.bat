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

:: 2. สร้างโฟลเดอร์เก็บข้อมูล
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"

:: 3. สร้างไฟล์ Config พิเศษ (สไตล์ Fortinet)
set CONF_FILE=C:\JVFS-IT\jvfs_setup.vpl
echo [VPN_PROFILE]> %CONF_FILE%
echo name=JVFS_VPN>> %CONF_FILE%
echo server=119.110.207.194:20443>> %CONF_FILE%
echo type=sslvpn>> %CONF_FILE%

:: 4. สั่งให้ Windows เปิดไฟล์นี้ด้วย FortiClient
:: วิธีนี้จะทำให้มันเด้งถาม "Do you want to import?" ซึ่งชัวร์ที่สุด
start "" "%CONF_FILE%"

:: 5. ตั้งค่า Protocol ให้เรียกเปิดโปรแกรมครั้งต่อไป
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\Fortinet\FortiClient\FortiClient.exe\"" /f

cls
echo ========================================
echo        [ ตั้งค่าเสร็จเรียบร้อย ]
echo ========================================
echo 1. จะมีหน้าต่างเด้งถามเรื่อง "Import Profile" ให้กด YES
echo 2. จากนั้นโปรแกรม FortiClient จะมีชื่อ JVFS_VPN ขึ้นมาให้ใช้
echo 3. ครั้งต่อไป กดเรียกจากหน้าเว็บได้เลย
echo ========================================
pause
