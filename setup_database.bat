@echo off
REM Database setup script for School Management System

echo Setting up SMS database...

REM Set MySQL credentials and paths
set MYSQL_USER=root
set MYSQL_PASSWORD=Dedecedric@1
set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 9.2\bin

REM Check if the MySQL directory exists
if not exist "%MYSQL_PATH%" (
    echo Error: MySQL directory not found at %MYSQL_PATH%
    echo Please update the MYSQL_PATH variable in this script with the correct path.
    exit /b 1
)

REM Create directory for SQL files if it doesn't exist
if not exist "src\main\resources" mkdir src\main\resources

REM Check if the SQL file exists
if not exist "src\main\resources\sms_database.sql" (
    echo Error: SQL script file not found at src\main\resources\sms_database.sql
    exit /b 1
)

REM Execute the SQL file
echo Executing SQL script...
"%MYSQL_PATH%\mysql" -u %MYSQL_USER% -p%MYSQL_PASSWORD% < src\main\resources\sms_database.sql

if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to execute SQL script.
    exit /b 1
)

echo Database setup complete!
echo You can now build and deploy the application.

exit /b 0 