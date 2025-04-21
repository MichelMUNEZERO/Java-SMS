@echo off
setlocal enabledelayedexpansion

REM Check Tomcat Status and Deployment
REM -------------------------------------------

echo.
echo School Management System - Tomcat Status
echo ========================================

set TOMCAT_HOME=C:\Program Files\Apache Software Foundation\Tomcat 9.0
set APP_URL=http://localhost:8080/sms

REM Check if Tomcat is running by looking for process
wmic process list brief | find /i "tomcat" > nul
if %ERRORLEVEL% EQU 0 (
    echo Tomcat is RUNNING
    set TOMCAT_RUNNING=yes
) else (
    echo Tomcat is NOT RUNNING
    set TOMCAT_RUNNING=no
)

REM Check Deployment Status
if "!TOMCAT_RUNNING!"=="yes" (
    echo.
    echo Checking application deployment...
    curl -s -o nul -w "%%{http_code}" %APP_URL% > temp_status.txt
    set /p STATUS_CODE=<temp_status.txt
    del temp_status.txt
    
    if "!STATUS_CODE!"=="200" (
        echo Application is successfully deployed at %APP_URL%
    ) else (
        echo Application returned status code !STATUS_CODE!
        echo There might be an issue with the deployment
    )
)

echo.
echo Options:
echo 1. Start Tomcat
echo 2. Stop Tomcat
echo 3. Restart Tomcat
echo 4. Deploy application
echo 5. Exit
echo.

set /p OPTION=Enter option (1-5): 

if "%OPTION%"=="1" (
    if "!TOMCAT_RUNNING!"=="yes" (
        echo Tomcat is already running.
    ) else (
        echo Starting Tomcat...
        start "" "%TOMCAT_HOME%\bin\startup.bat"
    )
) else if "%OPTION%"=="2" (
    if "!TOMCAT_RUNNING!"=="no" (
        echo Tomcat is not running.
    ) else (
        echo Stopping Tomcat...
        "%TOMCAT_HOME%\bin\shutdown.bat"
    )
) else if "%OPTION%"=="3" (
    echo Restarting Tomcat...
    if "!TOMCAT_RUNNING!"=="yes" (
        "%TOMCAT_HOME%\bin\shutdown.bat"
        timeout /t 5 /nobreak > nul
    )
    start "" "%TOMCAT_HOME%\bin\startup.bat"
) else if "%OPTION%"=="4" (
    echo Running build.bat to deploy the application...
    call build.bat
) else if "%OPTION%"=="5" (
    echo Exiting...
    exit /b 0
) else (
    echo Invalid option.
)

echo.
echo Done.
timeout /t 3 > nul

endlocal 