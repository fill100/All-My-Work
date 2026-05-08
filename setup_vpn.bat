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

:: 2. สร้างโฟลเดอร์ทำงาน
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"

:: 3. สร้างไฟล์ Config (.vpl) แบบ Force เขียนค่าเข้าไป
:: ไฟล์นี้จะเป็นตัวตั้งชื่อ Profile และ IP ให้เองอัตโนมัติ
set VPL_FILE="C:\JVFS-IT\JVFS_Config.vpl"
echo [VPN_Profile] > %VPL_FILE%
echo Type=SSL >> %VPL_FILE%
echo Name=JVFS_VPN >> %VPL_FILE%
echo Server=119.110.207.194 >> %VPL_FILE%
echo Port=20443 >> %VPL_FILE%
echo UserPrompt=1 >> %VPL_FILE%

:: 4. สั่งให้ FortiClient อ่านไฟล์นี้ (เพื่อ Import ค่าเข้าโปรแกรม)
start "" %VPL_FILE%
timeout /t 2 >nul

:: 5. สร้างไฟล์สำหรับเปิดโปรแกรมครั้งต่อๆ ไป (ผ่าน Protocol)
echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

:: 6. ลงทะเบียน Protocol jvfs-connect://
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

echo ========================================
echo [ ขั้นตอนสุดท้าย ]
echo - จะมีหน้าจอ FortiClient เด้งขึ้นมาถามว่า "Do you want to import...?"
echo - ให้ User ตอบ "Yes" (ตกลง) แค่ครั้งแรกครั้งเดียวครับ
echo - หลังจากนั้น Profile จะถูกตั้งค่าถาวรเลย!
echo ========================================
pause
