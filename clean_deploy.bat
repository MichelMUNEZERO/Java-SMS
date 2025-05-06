@echo off
echo Deploying School Management System with clean up...

REM Stop Tomcat if running
echo Stopping Tomcat server...
taskkill /F /IM java.exe /FI "WINDOWTITLE eq Apache Tomcat*" 2>NUL
timeout /t 2 /nobreak >NUL

REM Delete the old exploded WAR directory and WAR file
echo Removing old deployment...
if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\sms.war" del /F "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\sms.war"
if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\sms" rmdir /S /Q "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\sms"

REM Copy the WAR file to Tomcat webapps directory
echo Copying WAR file to Tomcat webapps directory...
copy ".\target\sms.war" "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\"

REM Check if copy was successful
if %ERRORLEVEL% NEQ 0 (
    echo Failed to copy WAR file to Tomcat webapps directory!
    exit /b %ERRORLEVEL%
)

REM Start Tomcat server
echo Starting Tomcat server...
start "Tomcat" "C:\Program Files\Apache Software Foundation\Tomcat 9.0\bin\startup.bat"

echo Deployment completed successfully!
echo Please wait while Tomcat deploys the application...
echo You can access the application at http://localhost:8083/sms 