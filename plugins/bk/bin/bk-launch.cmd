@echo off
rem Starts a BuildKeel component after checking for Node.js 20 or later.
rem Usage: bk-launch <server|hook> [args...]
rem BK_LAUNCH_DIST overrides the directory holding the built components.
setlocal EnableDelayedExpansion

set "REQUIRED_MAJOR=20"

set "TARGET=%~1"
if /I "%TARGET%"=="server" (set "ENTRY=server\main.js" & goto :target_ok)
if /I "%TARGET%"=="hook" (set "ENTRY=hooks\main.js" & goto :target_ok)
echo usage: bk-launch ^<server^|hook^> [args...] 1>&2
exit /b 64

:target_ok
if defined BK_LAUNCH_DIST (set "DIST=%BK_LAUNCH_DIST%") else (set "DIST=%~dp0..\dist")

set "ARGS="
:collect
shift
if "%~1"=="" goto :check
set ARGS=!ARGS! "%~1"
goto :collect

:check
where node >nul 2>nul
if errorlevel 1 (
  set "REASON=Node.js was not found on your PATH."
  goto :fail
)
set "VERSION="
for /f "delims=" %%v in ('node -p "process.versions.node" 2^>nul') do set "VERSION=%%v"
if not defined VERSION (
  set "REASON=Node.js could not be run."
  goto :fail
)
for /f "tokens=1 delims=." %%m in ("%VERSION%") do set "MAJOR=%%m"
set /a MAJOR_NUM=MAJOR 2>nul
if %MAJOR_NUM% LSS %REQUIRED_MAJOR% (
  set "REASON=Found Node.js %VERSION%."
  goto :fail
)

node "%DIST%\%ENTRY%" %ARGS%
exit /b %ERRORLEVEL%

:fail
echo BuildKeel needs Node.js %REQUIRED_MAJOR% or later. %REASON% 1>&2
echo Install it from https://nodejs.org or with your version manager (for example "nvm install %REQUIRED_MAJOR%"), then start a new session. 1>&2
exit /b 1
