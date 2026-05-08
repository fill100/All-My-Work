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

:: 2. ตั้งค่า VPN Profile ลงใน Registry (ทำให้ User ไม่ต้องกด Configure VPN เอง)
:: หมายเหตุ: ชื่อโปรไฟล์จะชื่อว่า "JVFS_VPN"
set REG_PATH="HKCU\Software\Fortinet\FortiClient\Sslvpn\Tunnels\JVFS_VPN"
reg add %REG_PATH% /v "Description" /t REG_SZ /d "JVFS_VPN" /f
reg add %REG_PATH% /v "Server" /t REG_SZ /d "119.110.207.194:20443" /f
reg add %REG_PATH% /v "promptcertificate" /t REG_DWORD /d 0 /f
reg add %REG_PATH% /v "promptuser" /t REG_DWORD /d 1 /f

:: 3. สร้างโฟลเดอร์และไฟล์เรียกโปรแกรม
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"

echo @echo off > "C:\JVFS-IT\connect_vpn.bat"
echo start "" "C:\Program Files\Fortinet\FortiClient\FortiClient.exe" >> "C:\JVFS-IT\connect_vpn.bat"

:: 4. ลงทะเบียน Protocol jvfs-connect://
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
:: แก้ไขการอ้างอิง Path ให้ใส่เครื่องหมายคำพูดป้องกัน Error จากช่องว่าง
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\"" /f

echo ========================================
echo [ Setup Complete ]
echo 1. ระบบตั้งค่า IP: 119.110.207.194 ให้เรียบร้อยแล้ว
echo 2. เมื่อกดจากเว็บ โปรแกรม FortiClient จะเปิดขึ้นมา
echo 3. ให้ User ใส่ Username/Password และกด Connect เอง
echo ========================================
pause