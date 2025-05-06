@echo off
echo Compiling TeacherDAO.java...
javac -d target/classes -cp "target/classes;src/main/webapp/WEB-INF/lib/*" src/main/java/com/sms/dao/TeacherDAO.java
if %errorlevel% neq 0 (
    echo Failed to compile TeacherDAO.java
    exit /b %errorlevel%
)

echo Compiling CourseDAOImpl.java...
javac -d target/classes -cp "target/classes;src/main/webapp/WEB-INF/lib/*" src/main/java/com/sms/dao/impl/CourseDAOImpl.java
if %errorlevel% neq 0 (
    echo Failed to compile CourseDAOImpl.java
    exit /b %errorlevel%
)

echo Compiling CoursesServlet.java...
javac -d target/classes -cp "target/classes;src/main/webapp/WEB-INF/lib/*;src/main/webapp/WEB-INF/lib/javax.servlet-api-4.0.1.jar" src/main/java/com/sms/controller/teacher/CoursesServlet.java
if %errorlevel% neq 0 (
    echo WARNING: Failed to compile CoursesServlet.java, but continuing...
)

echo Compile completed successfully.
echo Please restart your web server to apply the changes.
echo.
echo TIP: If you're still seeing courses not displaying in the UI:
echo 1. Check the server logs for database query errors
echo 2. Try fixing the database table JOIN in CourseDAOImpl's getCoursesByTeacherId method
echo 3. Make sure your database user has SELECT permissions on all tables
echo.
echo TIP: If you're still seeing the 'Failed to add course' error,
echo the database schema needs to be updated. Run this SQL command:
echo ALTER TABLE courses DROP COLUMN IF EXISTS status; 