@echo off
:: 1. ตรวจสอบสิทธิ์ Admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
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

:: 2. ปิดโปรแกรม FortiClient ก่อนเพื่อให้ Registry อัปเดต
taskkill /f /im FortiClient.exe >nul 2>&1

:: 3. ตั้งค่า VPN Profile (เขียนลงทั้ง 32 และ 64-bit เพื่อความชัวร์)
set VPN_NAME=JVFS_VPN
set VPN_SERVER=119.110.207.194:20443

:: Path สำหรับเครื่องทั่วไป
set REG_PATH="HKCU\Software\Fortinet\FortiClient\Sslvpn\Tunnels\%VPN_NAME%"
reg add %REG_PATH% /v "Description" /t REG_SZ /d "%VPN_NAME%" /f
reg add %REG_PATH% /v "Server" /t REG_SZ /d "%VPN_SERVER%" /f
reg add %REG_PATH% /v "promptcertificate" /t REG_DWORD /d 0 /f
reg add %REG_PATH% /v "promptuser" /t REG_DWORD /d 1 /f

:: 4. สร้างโฟลเดอร์เก็บ Script สำหรับเรียกใช้งาน
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"

:: สร้างไฟล์ BAT สำหรับเปิดโปรแกรม
echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

:: 5. ลงทะเบียน Protocol jvfs-connect://
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

echo ========================================
echo [ แก้ไขการตั้งค่าเรียบร้อย ]
echo - สร้างโปรไฟล์ชื่อ: %VPN_NAME%
echo - เซิร์ฟเวอร์: %VPN_SERVER%
echo.
echo ลองเปิดโปรแกรม FortiClient ดูอีกครั้งครับ
echo หรือลองกด link: jvfs-connect:// ในเบราว์เซอร์
echo ========================================
pause
