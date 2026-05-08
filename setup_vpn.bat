@echo off
:: 1. สร้างโฟลเดอร์เก็บ Script
if not exist "C:\JVFS-IT" mkdir "C:\JVFS-IT"

:: 2. สร้างไฟล์ Script สำหรับเชื่อมต่อ VPN
echo @echo off > C:\JVFS-IT\connect_vpn.bat
echo "C:\Program Files\Fortinet\FortiClient\FortiSSLVPNclient.exe" connect -h 119.110.207.194:20443 >> C:\JVFS-IT\connect_vpn.bat

:: 3. ลงทะเบียน Protocol jvfs-connect:// ใน Registry
reg add "HKCR\jvfs-connect" /ve /t REG_SZ /d "URL:JVFS VPN Protocol" /f
reg add "HKCR\jvfs-connect" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKCR\jvfs-connect\shell\open\command" /ve /t REG_SZ /d "\"C:\JVFS-IT\connect_vpn.bat\" \"%%1\"" /f

echo Setup Complete! Now you can use One-Click Connect.
pause