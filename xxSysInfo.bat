@ECHO off

REM Clean and Configure
SET ST=%time%
SETLOCAL EnableDelayedExpansion
TITLE Status: Working...
COLOR 0a
CLS
chcp 65001>nul 

REM Heading
ECHO ==========================
ECHO === xxSysInfo v1.0
ECHO ========================== 
ECHO = Usage: xxSysInfo.bat -l D:\info.txt
ECHO = Or just: xxSysInfo.bat for default log file.
ECHO ========================== 
ECHO.

REM Input parameters
if "%~1"=="-l" (GOTO SPECIFIC) ELSE (GOTO UNKNOWN)
:SPECIFIC
SET "logfile=%~2"
ECHO Using %logfile% as log file.
GOTO CONTINUE
:UNKNOWN
SET "logfile=%cd%sysInfo.txt"
ECHO Using %logfile% as log file.
GOTO CONTINUE
:CONTINUE

REM Check logfile existance
if EXIST %logfile%. (
    ECHO Warning: File exists. 
    ECHO Appending information...
) ELSE (
    ECHO File created. 
    ECHO Appending information...
)

REM Date
ECHO ============= >> %logfile%
ECHO === Log created at: >> %logfile%
ECHO ============= >> %logfile%
ECHO Date and time: >> %logfile% 
ECHO %date%-%time% >> %logfile% 2>&1
ECHO Timezone: >> %logfile% 
wmic Timezone get DaylightName,Description,StandardName |more >> %logfile% 2>&1

REM Basic Information
ECHO ============= >> %logfile%
ECHO === Basic Information: >> %logfile%
ECHO ============= >> %logfile%
ECHO Output of whoami: >> %logfile%
whoami >> %logfile% 2>&1
ECHO Output of %^%username%^%: >> %logfile% 
ECHO %username% >> %logfile% 2>&1
ECHO Output of %^%computername%^%: >> %logfile% 
ECHO %computername% >> %logfile% 2>&1

REM Net Users
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Net Users: >> %logfile%
ECHO ============= >> %logfile%
net users >> %logfile% 2>&1

REM Environment Variables
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Environment Variables: >> %logfile%
ECHO ============= >> %logfile%
ECHO Output of SET: >> %logfile% 
set >> %logfile% 2>&1
ECHO Output of %^%cmdextversion%^%: >> %logfile% 
echo %cmdextversion% >> %logfile% 2>&1
ECHO Output of %^%cmdcmdline%^%: >> %logfile% 
echo %cmdcmdline% >> %logfile% 2>&1
ECHO Output of %^%errorlevel%^%: >> %logfile% 
echo %errorlevel% >> %logfile% 2>&1

REM Full Systeminfo
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Full Systeminfo: >> %logfile%
ECHO ============= >> %logfile%
systeminfo >> %logfile% 2>&1

REM IPConfig
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === IPConfig: >> %logfile%
ECHO ============= >> %logfile%
ipconfig /all >> %logfile% 2>&1

REM Routes
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Routes: >> %logfile%
ECHO ============= >> %logfile%
route print >> %logfile% 2>&1

REM ARP
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === ARP: >> %logfile%
ECHO ============= >> %logfile%
arp -A >> %logfile% 2>&1

REM Netstat
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Netstat: >> %logfile%
ECHO ============= >> %logfile%
netstat -ano >> %logfile% 2>&1

REM Firewall State
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Firewall State: >> %logfile%
ECHO ============= >> %logfile%
netsh firewall show state >> %logfile% 2>&1

REM Firewall Config
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Firewall Config: >> %logfile%
ECHO ============= >> %logfile%
netsh firewall show config >> %logfile% 2>&1

REM Scheduled Tasks
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Scheduled Tasks: >> %logfile%
ECHO ============= >> %logfile%
schtasks /query /fo LIST /v >> %logfile% 2>&1

REM Processes
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Processes: >> %logfile%
ECHO ============= >> %logfile%
ECHO Tasklist: >> %logfile% 2>&1
tasklist /SVC >> %logfile% 2>&1
ECHO WMIC: >> %logfile% 2>&1
wmic process get CSName,Description,ExecutablePath,ProcessId |more >> %logfile% 2>&1

REM Services
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Services: >> %logfile%
ECHO ============= >> %logfile%
ECHO Net: >> %logfile% 2>&1
net start >> %logfile% 2>&1
ECHO WMIC: >> %logfile% 2>&1
wmic service get Caption,Name,PathName,ServiceType,Started,StartMode,StartName |more >> %logfile% 2>&1

REM Driver Information
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Driver Information: >> %logfile%
ECHO ============= >> %logfile%
DRIVERQUERY >> %logfile% 2>&1

REM Windows Updates Information
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Windows Updates Information: >> %logfile%
ECHO ============= >> %logfile%
wmic qfe get Caption,Description,HotFixID,InstalledOn |more >> %logfile% 2>&1

REM %path%
ECHO ============= >> %logfile%
ECHO === Output of %^%path%^%: >> %logfile%
ECHO ============= >> %logfile%
ECHO %path% >> %logfile% 2>&1

REM Useraccount SID
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Useraccount SID: >> %logfile%
ECHO ============= >> %logfile%
wmic useraccount where name='%username%' get sid |more >> %logfile% 2>&1

REM IE Version
ECHO ============= >> %logfile%
ECHO === IE versions: >> %logfile%
ECHO ============= >> %logfile%
%windir%\system32\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer" /v svcVersion >NUL 2>NUL
if not ErrorLevel 1 (
  FOR /f "usebackq tokens=3" %%i in (`%windir%\system32\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer" /v svcVersion ^| %windir%\system32\findstr /i /l /c:"REG_SZ"`) do SET _IEVersion=%%i
) else (
  REM svcVersion KEY NOT Found. Must be IE9 or earlier so use Version Key
  FOR /f "usebackq tokens=3" %%i in (`%windir%\system32\reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer" /v Version ^| %windir%\system32\findstr /i /l /c:"REG_SZ"`) do SET _IEVersion=%%i
)
REM Get IE major version
FOR /f "tokens=1 Delims=." %%i in ("%_IEVERSION%") do SET _IEMajorVersion=%%i
ECHO Major: %_IEMajorVersion% ^| Minor: %_IEVersion% >> %logfile% 2>&1

REM Service Pack Information
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Service Pack Information: >> %logfile%
ECHO ============= >> %logfile%
wmic os get ServicePackMajorVersion /value |more >> %logfile% 2>&1

REM  Drives
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Drives: >> %logfile%
ECHO ============= >> %logfile%
ECHO System Drive: >> %logfile% 2>&1
ECHO %systemdrive% >> %logfile% 2>&1
ECHO All drives: >> %logfile% 2>&1
fsutil fsinfo drives >> %logfile% 2>&1
ECHO System drive type: >> %logfile% 2>&1
fsutil fsinfo driveType %systemdrive% >> %logfile% 2>&1
ECHO WMIC: >> %logfile% 2>&1
wmic volume get Label,DeviceID,DriveLetter,FileSystem,Capacity,FreeSpace |more >> %logfile% 2>&1

REM CPU
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === CPU: >> %logfile%
ECHO ============= >> %logfile%
ECHO Architecture: >> %logfile% 2>&1
ECHO %processor_architecture% >> %logfile% 2>&1
ECHO WMIC: >> %logfile% 2>&1
wmic CPU get Description, DeviceID, Manufacturer, MaxClockSpeed, Name, Status, SystemName |more >> %logfile% 2>&1

REM Network Shares
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Network Shares: >> %logfile%
ECHO ============= >> %logfile%
wmic netuse list |more >> %logfile% 2>&1

REM Full Group List
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Full Group List: >> %logfile%
ECHO ============= >> %logfile%
wmic group list full |more >> %logfile% 2>&1

REM Full Useraccounts List
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Full Useraccounts List: >> %logfile%
ECHO ============= >> %logfile%
wmic USERACCOUNT list full |more >> %logfile% 2>&1

REM Products
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Products: >> %logfile%
ECHO ============= >> %logfile%
wmic PRODUCT get Description,InstallDate,InstallLocation,PackageCache,Vendor,Version |more >> %logfile% 2>&1

REM Startup
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === Startup: >> %logfile%
ECHO ============= >> %logfile%
wmic startup get Caption,Command,Location,User |more >> %logfile% 2>&1

REM OS
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === OS: >> %logfile%
ECHO ============= >> %logfile%
wmic os get name,version,InstallDate,LastBootUpTime,LocalDateTime,Manufacturer,RegisteredUser,ServicePackMajorVersion,SystemDirectory |more >> %logfile% 2>&1

REM NIC
ECHO. >> %logfile%
ECHO ============= >> %logfile%
ECHO === NIC: >> %logfile%
ECHO ============= >> %logfile%
wmic nicconfig where IPEnabled='true' get Caption,DefaultIPGateway,Description,DHCPEnabled,DHCPServer,IPAddress,IPSubnet,MACAddress |more >> %logfile% 2>&1

REM Nice ending
TITLE Status: Done.
REM Start, end time difference and adjustments
FOR /f "tokens=1-3 delims=:" %%a in ("%ST%") do SET /a h1=%%a & SET /a m1=%%b & SET /a s1=%%c
FOR /f "tokens=1-3 delims=:" %%a in ("%TIME%") do SET /a h2=%%a & SET /a m2=%%b & SET /a s2=%%c
SET /a h3=%h2%-%h1% & SET /a m3=%m2%-%m1% & SET /a s3=%s2%-%s1%
if %h3% LSS 0 SET /a h3=%h3%+24
if %m3% LSS 0 SET /a m3=%m3%+60 & SET /a h3=%h3%-1
if %s3% LSS 0 SET /a s3=%s3%+60 & SET /a m3=%m3%-1
REM Calculate log size
FOR %%I in (%logfile%) do SET /a xbytesize=%%~zI
SET /a xmbsize=%xbytesize%/1024/1024
ECHO Generated %xbytesize% bytes (~%xmbsize% mb) log file in %h3%:%m3%:%s3% seconds.
ECHO.
ECHO =============
ECHO Done!
ECHO =============
ECHO.
ECHO Press any key to exit...
PAUSE>nul
EXIT