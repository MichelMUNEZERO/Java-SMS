@echo off
REM Build script for School Management System

REM Set Java home path for JDK-21
set JAVA_HOME=C:\Program Files\Java\jdk-21
echo Using Java from %JAVA_HOME%
set JRE_HOME=%JAVA_HOME%
set PATH=%JAVA_HOME%\bin;%PATH%

REM Set Maven home path
set MAVEN_HOME=C:\Program Files\Apache Software Foundation\Maven\apache-maven-3.9.9
echo Using Maven from %MAVEN_HOME%

REM Add Maven bin to PATH
set PATH=%MAVEN_HOME%\bin;%PATH%

REM Set Tomcat path - Update this to your actual Tomcat installation path if needed
if "%CATALINA_HOME%" == "" (
    set CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 9.0
    echo CATALINA_HOME not set. Using default: %CATALINA_HOME%
) else (
    echo Using CATALINA_HOME: %CATALINA_HOME%
)

REM Clean and package the application
echo Building School Management System...
call "%MAVEN_HOME%\bin\mvn.cmd" clean package

if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    exit /b %ERRORLEVEL%
)

echo.
echo Build successful! WAR file created at: target\sms.war
echo.

REM Check if Tomcat webapps directory exists
if exist "%CATALINA_HOME%\webapps" (
    echo Copying WAR file to Tomcat webapps directory...
    copy /Y target\sms.war "%CATALINA_HOME%\webapps\"
    
    REM Remove old extracted directory if it exists to ensure clean deployment
    if exist "%CATALINA_HOME%\webapps\sms" (
        echo Removing old deployment directory...
        rmdir /S /Q "%CATALINA_HOME%\webapps\sms"
    )
    
    echo Deployment complete!
    
    echo Stopping Tomcat if running...
    call "%CATALINA_HOME%\bin\shutdown.bat"
    
    REM Wait for Tomcat to fully stop
    echo Waiting for Tomcat to stop...
    timeout /t 10 /nobreak > nul
    
    echo Starting Tomcat...
    start "" "%CATALINA_HOME%\bin\startup.bat"
    
    echo Tomcat started. Your application should be available at http://localhost:8080/sms/
    echo Opening application in default browser...
    timeout /t 5 /nobreak > nul
    start "" http://localhost:8080/sms/
) else (
    echo ERROR: Tomcat webapps directory not found at %CATALINA_HOME%\webapps
    echo Please set the correct CATALINA_HOME environment variable or update this script.
    pause
    exit /b 1
)

echo.
echo Build, deployment and server start completed successfully.
echo.

exit /b 0