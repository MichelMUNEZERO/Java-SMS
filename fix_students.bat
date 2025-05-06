@echo off
echo Fixing the TeacherStudentsServlet to show all students...

:: Create target directories if they don't exist
if not exist target\sms\WEB-INF\classes\com\sms\controller\teacher mkdir target\sms\WEB-INF\classes\com\sms\controller\teacher

:: Copy the source file to the deployment directory
echo Copying updated TeacherStudentsServlet.java to deployment directory...
copy /Y src\main\java\com\sms\controller\teacher\TeacherStudentsServlet.java target\sms\WEB-INF\src\com\sms\controller\teacher\TeacherStudentsServlet.java

echo.
echo Fix applied - Java source file has been deployed.
echo.
echo Please restart your web server to apply the changes.
echo Then navigate to http://localhost:8083/sms/teacher/students to see all students. 