@echo off
rem Starts a BuildKeel component after checking for Node.js 20 or later
rem (the version itself is checked by bk-start.cjs).
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
rem Taken before the arguments are shifted: shift moves the script's own path too.
set "HERE=%~dp0"
if defined BK_LAUNCH_DIST (set "DIST=%BK_LAUNCH_DIST%") else (set "DIST=%HERE%..\dist")

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
rem bk-start.cjs checks the version and runs the component in one Node process.
node "%HERE%bk-start.cjs" "%DIST%\%ENTRY%" %ARGS%
exit /b %ERRORLEVEL%

:fail
echo BuildKeel needs Node.js %REQUIRED_MAJOR% or later. %REASON% 1>&2
echo Install it from https://nodejs.org or with your version manager (for example "nvm install %REQUIRED_MAJOR%"), then start a new session. 1>&2
exit /b 1
