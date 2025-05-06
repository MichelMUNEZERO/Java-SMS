@echo off
echo Compiling TeacherStudentsServlet.java...

:: Set classpath with servlet API and other dependencies
set CLASSPATH=target\sms\WEB-INF\lib\*;target\sms\WEB-INF\classes

:: Make sure target directories exist
if not exist target\classes\com\sms\controller\teacher mkdir target\classes\com\sms\controller\teacher

:: Compile the servlet
javac -d target\classes -cp "%CLASSPATH%" src\main\java\com\sms\controller\teacher\TeacherStudentsServlet.java

:: Check if compilation was successful
if %errorlevel% neq 0 (
    echo ERROR: Failed to compile TeacherStudentsServlet.java
    exit /b %errorlevel%
)

echo Compilation successful.

:: Copy compiled class to deployment directory
echo Copying compiled class file to deployment directory...
copy /Y target\classes\com\sms\controller\teacher\TeacherStudentsServlet.class target\sms\WEB-INF\classes\com\sms\controller\teacher\

if %errorlevel% neq 0 (
    echo ERROR: Failed to copy compiled class file.
    exit /b %errorlevel%
)

echo.
echo Fix successfully applied!
echo.
echo Please restart your web server to see all students at http://localhost:8083/sms/teacher/students 