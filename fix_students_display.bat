@echo off
echo Compiling TeacherStudentsServlet.java...

:: Set up classpath including servlet API and other libraries
set CLASSPATH=target\classes;target\sms\WEB-INF\classes;target\sms\WEB-INF\lib\*

:: Create folders if they don't exist
if not exist target\classes\com\sms\controller\teacher mkdir target\classes\com\sms\controller\teacher

:: Compile the TeacherStudentsServlet class
javac -d target\classes -cp "%CLASSPATH%" src\main\java\com\sms\controller\teacher\TeacherStudentsServlet.java

:: Check if compilation was successful
if %errorlevel% neq 0 (
    echo Error compiling TeacherStudentsServlet.java
    exit /b %errorlevel%
)

:: Copy compiled class to the deployment directory
echo Copying compiled class to deployment directory...
copy /Y target\classes\com\sms\controller\teacher\TeacherStudentsServlet.class target\sms\WEB-INF\classes\com\sms\controller\teacher\

echo.
echo Fix completed successfully.
echo.
echo Please restart your web server to apply the changes.
echo Then navigate to http://localhost:8083/sms/teacher/students to see all students. 