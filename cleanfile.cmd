@echo off
rem Clean temporary files
del /q /s C:\Users%USERNAME%\AppData\Local\Temp*
del /q /s C:\Windows\Temp*
rd /s /q C:\Windows\Temp
md C:\Windows\Temp
del /q /s C:\Windows\Prefetch*
rem Clean thumbnail cache
del /q /s C:\Users%USERNAME%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_.db
rem Clean old update files
dism.exe /online /cleanup-image /startcomponentcleanup /resetbase
rem Analyze system components and clean up unused files
dism.exe /online /cleanup-image /analyzecomponentstore
rem Clean up registry
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages /f
rem Clean browser cache and history
del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache*."
del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache*."
del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache*."
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache"
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache"
del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache*."
del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache*."
del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Media Cache*."
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache"
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Media Cache"
del /q /s /f "%LOCALAPPDATA%\Mozilla\Firefox\Profiles*\cache2*."
rd /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles*\cache2"
del /q /s /f "%LOCALAPPDATA%\Mozilla\Firefox\Profiles*\thumbnails*."
rd /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles*\thumbnails"
del /q /s /f "%LOCALAPPDATA%\Mozilla\Firefox\Profiles*\startupCache*."
rd /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles*\startupCache"
rem Clean printer spool
del /q /s /f C:\Windows\System32\spool\printers*
rem Clean log files
wevtutil el | Foreach-Object {wevtutil cl "$"}
rem Clean Windows error reporting
del /q /s /f C:\ProgramData\Microsoft\Windows\WER\ReportQueue*
rem Clean memory dumps
del /q /s /f C:\Windows\Memory.dmp
del /q /s /f C:\Windows\Minidump*
rd /s /q C:\Windows\Minidump
rem Clean old Windows update files
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
rem Optimize hard drive
defrag C: /U /V
rem Empty recycle bin
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {$RecycleBin = New-Object -ComObject 'Shell.Application' ; $RecycleBin.Items() | %{Remove-Item $.Path -Recurse -Confirm:$false}}"
rem Restart computer
shutdown /r /t 0
