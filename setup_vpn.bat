@echo off
chcp 65001 >nul
:: 1. ตรวจสอบสิทธิ์ Admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( goto UACPrompt ) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: 2. ปิดโปรแกรมที่ค้างอยู่
taskkill /f /im FortiClient.exe >nul 2>&1

:: 3. สร้างไฟล์ config แบบ XML ที่ FortiClient 7.2 อ่านออก
set CONFIG_DIR=%AppData%\Fortinet\FortiClient\config
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

:: 4. สร้างตัวเรียกโปรแกรม (Protocol)
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"
echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

:: 5. เปิดโปรแกรมขึ้นมาใหม่
start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"

cls
echo ========================================
echo        [ บังคับตั้งค่าสำเร็จแล้ว! ]
echo ========================================
echo - ระบบได้ยัดไฟล์ Config เข้าไปในเครื่องแล้ว
echo - ตอนนี้หน้าจอ FortiClient ควรจะเปลี่ยนจาก 
echo   "Configure VPN" เป็นหน้าใส่ Username แล้วครับ
echo ========================================
pause
