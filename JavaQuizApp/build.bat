@echo off
echo ========================================================
echo Building Online Quiz Application (Java + Servlets + JSP)
echo ========================================================

REM Find servlet api jar in local m2 cache
set SERVLET_JAR=%USERPROFILE%\.m2\repository\jakarta\servlet\jakarta.servlet-api\6.0.0\jakarta.servlet-api-6.0.0.jar

if not exist "%SERVLET_JAR%" (
    echo [WARNING] Servlet JAR not found in .m2 cache. If using Maven, run 'mvn package'.
)

echo [1/3] Compiling Java source files...
if not exist "target\classes" mkdir "target\classes"
javac -cp "%SERVLET_JAR%" -d "target\classes" src\main\java\com\quiz\model\*.java src\main\java\com\quiz\util\*.java src\main\java\com\quiz\filter\*.java src\main\java\com\quiz\servlet\*.java
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Compilation failed!
    pause
    exit /b %ERRORLEVEL%
)

echo [2/3] Assembling WAR layout...
if not exist "target\JavaQuizApp\WEB-INF\classes" mkdir "target\JavaQuizApp\WEB-INF\classes"
xcopy /s /y /q "src\main\webapp\*" "target\JavaQuizApp\"
xcopy /s /y /q "target\classes\*" "target\JavaQuizApp\WEB-INF\classes\"

echo [3/3] Packaging JavaQuizApp.war...
cd target\JavaQuizApp
jar -cvf "..\JavaQuizApp.war" * > nul
cd ..\..

echo.
echo ========================================================
echo BUILD SUCCESSFUL!
echo Generated WAR file: target\JavaQuizApp.war
echo ========================================================

