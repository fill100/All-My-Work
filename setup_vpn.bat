@echo off
chcp 65001 >nul
title JVFS VPN Helper

:: 1. ขอสิทธิ์ Admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( goto UACPrompt ) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs" & exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

:: 2. ลงทะเบียน Protocol jvfs-connect:// (เพื่อให้ปุ่มบนเว็บกดติด)
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\Fortinet\FortiClient\FortiClient.exe\"" /f

cls
echo ======================================================
echo          [ ขั้นตอนการตั้งค่า JVFS VPN ]
echo ======================================================
echo  เนื่องจาก FortiClient 7.2 มีระบบความปลอดภัยสูง 
echo  รบกวนตั้งค่าด้วยตนเอง "ครั้งแรกครั้งเดียว" ดังนี้:
echo.
echo  1. ในหน้าโปรแกรม กดปุ่ม "Configure VPN"
echo  2. Connection Name: JVFS_VPN
echo  3. Remote Gateway : 119.110.207.194
echo  4. Port           : 20443
echo  5. กดปุ่ม [ SAVE ]
echo.
echo ======================================================
echo  เมื่อตั้งค่าเสร็จแล้ว ปุ่มบนหน้าเว็บจะใช้งานได้ทันที!
echo ======================================================
pause