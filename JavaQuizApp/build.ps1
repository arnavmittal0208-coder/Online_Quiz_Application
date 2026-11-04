Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Building Online Quiz Application (Java + Servlets + JSP)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$servletJar = "$env:USERPROFILE\.m2\repository\jakarta\servlet\jakarta.servlet-api\6.0.0\jakarta.servlet-api-6.0.0.jar"
$distDir = "$scriptDir\target\JavaQuizApp"
$classesDir = "$scriptDir\target\classes"

Write-Host "[1/3] Compiling Java classes..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $classesDir | Out-Null
$sources = Get-ChildItem -Path "$scriptDir\src\main\java" -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName
javac -cp "$servletJar" -d "$classesDir" $sources

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Compilation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "[2/3] Assembling web application directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$distDir\WEB-INF\classes" | Out-Null
Copy-Item -Path "$scriptDir\src\main\webapp\*" -Destination "$distDir\" -Recurse -Force
Copy-Item -Path "$classesDir\*" -Destination "$distDir\WEB-INF\classes\" -Recurse -Force

Write-Host "[3/3] Packaging target\JavaQuizApp.war..." -ForegroundColor Yellow
Set-Location $distDir
jar -cvf "..\JavaQuizApp.war" * | Out-Null
Set-Location $scriptDir

Write-Host "========================================================" -ForegroundColor Green
Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "Package created at: $scriptDir\target\JavaQuizApp.war" -ForegroundColor Green
Write-Host "Deploy this WAR file into Tomcat's 'webapps' folder." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

