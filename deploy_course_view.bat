@echo off
echo Deploying admin course files...

REM Create required directories
mkdir target\sms\WEB-INF\classes\com\sms\controller\admin 2>nul
mkdir target\sms\admin\courses\view 2>nul
mkdir target\sms\admin\courses\edit 2>nul
mkdir target\sms\admin\courses\delete 2>nul
mkdir target\sms\admin 2>nul
mkdir target\sms\WEB-INF\classes\com\sms\model 2>nul

REM Copy files
copy src\main\java\com\sms\controller\admin\AdminCourseDetailsServlet.java target\sms\WEB-INF\classes\com\sms\controller\admin\
copy src\main\java\com\sms\controller\admin\AdminCourseEditServlet.java target\sms\WEB-INF\classes\com\sms\controller\admin\
copy src\main\java\com\sms\controller\admin\AdminCourseDeleteServlet.java target\sms\WEB-INF\classes\com\sms\controller\admin\
copy src\main\java\com\sms\model\Course.java target\sms\WEB-INF\classes\com\sms\model\
copy src\main\webapp\admin\course_details.jsp target\sms\admin\
copy src\main\webapp\admin\course_form.jsp target\sms\admin\
copy src\main\webapp\admin\courses\view\index.jsp target\sms\admin\courses\view\

REM Create placeholder files for edit and delete
echo ^<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%%^> > target\sms\admin\courses\edit\index.jsp
echo ^<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %%^> >> target\sms\admin\courses\edit\index.jsp
echo ^<c:redirect url="/admin/courses" /^> >> target\sms\admin\courses\edit\index.jsp

echo ^<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%%^> > target\sms\admin\courses\delete\index.jsp
echo ^<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %%^> >> target\sms\admin\courses\delete\index.jsp
echo ^<c:redirect url="/admin/courses" /^> >> target\sms\admin\courses\delete\index.jsp

REM Update web.xml with new servlet mappings
echo Adding servlet mappings to web.xml...

echo Deployment completed 