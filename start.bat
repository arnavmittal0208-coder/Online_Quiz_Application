@echo off
setlocal
cd /d "%~dp0"
title Online Quiz Application Launcher

echo ============================================================
echo   Online Quiz Application - Startup Launcher
echo ============================================================
echo.

set "BASE_DIR=%~dp0"
if "%BASE_DIR:~-1%"=="\" set "BASE_DIR=%BASE_DIR:~0,-1%"

REM Configure Java environment
if not defined JAVA_HOME (
    if exist "C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot" (
        set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
    )
)
REM Strip trailing backslash from JAVA_HOME if present
if defined JAVA_HOME if "%JAVA_HOME:~-1%"=="\" set "JAVA_HOME=%JAVA_HOME:~0,-1%"

set "WAR_FILE=%BASE_DIR%\JavaQuizApp.war"
if not exist "%WAR_FILE%" (
    if exist "%BASE_DIR%\JavaQuizApp\target\JavaQuizApp.war" (
        copy /y "%BASE_DIR%\JavaQuizApp\target\JavaQuizApp.war" "%WAR_FILE%" >nul
    )
)

if not exist "%WAR_FILE%" (
    echo [ERROR] JavaQuizApp.war was not found in:
    echo         %BASE_DIR%
    echo.
    pause
    exit /b 1
)

echo [1/3] Locating Apache Tomcat...
set "TOMCAT_DIR="

REM Check 1: Nested folder in %BASE_DIR%\tomcat
for /d %%D in ("%BASE_DIR%\tomcat\apache-tomcat*") do (
    if exist "%%D\bin\catalina.bat" (
        set "TOMCAT_DIR=%%D"
        goto tomcat_ready
    )
)

REM Check 2: Direct %BASE_DIR%\tomcat
if exist "%BASE_DIR%\tomcat\bin\catalina.bat" (
    set "TOMCAT_DIR=%BASE_DIR%\tomcat"
    goto tomcat_ready
)

REM Check 3: Downloads folder
for /d %%D in ("%USERPROFILE%\Downloads\apache-tomcat*") do (
    if exist "%%D\bin\catalina.bat" (
        set "TOMCAT_DIR=%%D"
        goto tomcat_ready
    )
    for /d %%S in ("%%D\apache-tomcat*") do (
        if exist "%%S\bin\catalina.bat" (
            set "TOMCAT_DIR=%%S"
            goto tomcat_ready
        )
    )
)

REM Check 4: Desktop
for /d %%D in ("%USERPROFILE%\Desktop\apache-tomcat*") do (
    if exist "%%D\bin\catalina.bat" (
        set "TOMCAT_DIR=%%D"
        goto tomcat_ready
    )
)

REM Check 5: C:\ root
for /d %%D in ("C:\apache-tomcat*") do (
    if exist "%%D\bin\catalina.bat" (
        set "TOMCAT_DIR=%%D"
        goto tomcat_ready
    )
)

echo [ERROR] Apache Tomcat was not found.
echo Please extract Apache Tomcat into:
echo   %BASE_DIR%\tomcat
echo.
pause
exit /b 1

:tomcat_ready
echo [OK] Tomcat located at:
echo      %TOMCAT_DIR%
echo.

REM 2. Deploy WAR file to webapps
echo [2/3] Deploying JavaQuizApp.war...
if not exist "%TOMCAT_DIR%\webapps" mkdir "%TOMCAT_DIR%\webapps"
copy /y "%WAR_FILE%" "%TOMCAT_DIR%\webapps\JavaQuizApp.war" >nul
echo [OK] WAR deployed to webapps.
echo.

REM 3. Start Apache Tomcat
echo [3/3] Starting Apache Tomcat server...
set "CATALINA_HOME=%TOMCAT_DIR%"
set "CATALINA_BASE=%TOMCAT_DIR%"

start "Apache Tomcat (Online Quiz)" /d "%TOMCAT_DIR%\bin" startup.bat
echo [OK] Server process initiated.
echo.

echo ============================================================
echo   APPLICATION IS RUNNING!
echo ============================================================
echo.
echo   Browser URL: http://localhost:8080/JavaQuizApp/
echo.
echo   Login Accounts:
echo     - Instructor:  admin    / admin123
echo     - Student:     student1 / student123
echo.
echo ============================================================
echo Opening http://localhost:8080/JavaQuizApp/ in your browser...

ping 127.0.0.1 -n 4 >nul
start http://localhost:8080/JavaQuizApp/

echo.
echo Keep the Tomcat console window open while using the application.
echo To stop Tomcat, run stop.bat or close the Tomcat console window.
echo.
pause
