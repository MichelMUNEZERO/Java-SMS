@echo off
echo Starting the fix for the student display issue...

:: First, rename the existing TeacherStudentsServlet.class file as backup
echo Creating backup of current TeacherStudentsServlet.class...
rename "target\sms\WEB-INF\classes\com\sms\controller\teacher\TeacherStudentsServlet.class" "TeacherStudentsServlet.class.original"

if %errorlevel% neq 0 (
    echo ERROR: Could not create backup of TeacherStudentsServlet.class
    exit /b %errorlevel%
)

:: Next, copy TeacherStudentServlet.class to the server deployment directory with the proper name
echo Copying TeacherStudentServlet.class as TeacherStudentsServlet.class (which uses getAllStudents)...
copy /Y "target\sms\WEB-INF\classes\com\sms\controller\teacher\TeacherStudentServlet.class" "target\sms\WEB-INF\classes\com\sms\controller\teacher\TeacherStudentsServlet.class"

if %errorlevel% neq 0 (
    echo ERROR: Could not copy TeacherStudentServlet.class
    echo Restoring original file...
    rename "target\sms\WEB-INF\classes\com\sms\controller\teacher\TeacherStudentsServlet.class.original" "TeacherStudentsServlet.class"
    exit /b %errorlevel%
)

echo.
echo Fix has been applied!
echo.
echo Please restart your web server to see all students at http://localhost:8083/sms/teacher/students 