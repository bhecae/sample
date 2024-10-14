@echo off
setlocal enabledelayedexpansion

:: Define variables
set "logfile=C:\website_log.txt"
set "url=https://www.theshineapp.com"

:: Get the date and time today
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set "date=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%"

:: Get the username of the computer
set "username=%USERNAME%"

:: Log the date, username, and URL
echo Date Tested: %date% >> %logfile%
echo Tester: %username% >> %logfile%
echo. >> "%LOGFILE%"
echo PERFORMANCE TEST >> "%LOGFILE%"
echo. >> "%LOGFILE%"
echo URL: %url% >> %logfile%

:: Open the website and measure the load time
set starttime=%time%
start "" "%url%"
timeout /t 10 >nul
set endtime=%time%

:: Calculate the duration
for /f "tokens=1-4 delims=:., " %%a in ("%starttime%") do (
set /a "startms=(((%%a*60)+1%%b%%100)*60+1%%c%%100)*100+1%%d%%100"
)
for /f "tokens=1-4 delims=:., " %%a in ("%endtime%") do (
set /a "endms=(((%%a*60)+1%%b%%100)*60+1%%c%%100)*100+1%%d%%100"
)
set /a duration=endms-startms

:: Log the duration
echo Duration: %duration% milliseconds >> %logfile%

REM Check if Skype is running and kill it if found
tasklist | find /i "Skype.exe" >nul 2>&1
if %errorlevel%==0 (
taskkill /f /im Skype.exe
echo. >> "%LOGFILE%"
echo APPLICATION TEST >> "%LOGFILE%"
echo. >> "%LOGFILE%"
echo Skype was killed at %date% %time% by %username% >> %logfile%
echo Skype was running and has been killed by %username%.
) else (
echo Skype is not running.
)


echo Performance test completed. Check %LOGFILE% for results.
endlocal