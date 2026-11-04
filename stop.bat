@echo off
setlocal
cd /d "%~dp0"
title Stopping Online Quiz Application...

echo ============================================================
echo   Stopping Apache Tomcat Server...
echo ============================================================

set "BASE_DIR=%~dp0"
if "%BASE_DIR:~-1%"=="\" set "BASE_DIR=%BASE_DIR:~0,-1%"

for /d %%D in ("%BASE_DIR%\tomcat\apache-tomcat*") do (
    if exist "%%D\bin\shutdown.bat" (
        call "%%D\bin\shutdown.bat"
        goto stopped
    )
)

if exist "%BASE_DIR%\tomcat\bin\shutdown.bat" (
    call "%BASE_DIR%\tomcat\bin\shutdown.bat"
    goto stopped
)

echo [INFO] You can close the Tomcat console window directly.
goto finish

:stopped
echo [OK] Tomcat shutdown signal sent successfully!

:finish
ping 127.0.0.1 -n 3 >nul
