@echo off
setlocal enabledelayedexpansion

REM Script to install Git hooks
REM Platform: Windows

echo Installing Git hooks...

REM Get the directory of this script
set "SCRIPT_DIR=%~dp0"

REM Get the git hooks directory
set "HOOKS_DIR=%SCRIPT_DIR%..\.git\hooks"

REM Create hooks directory if it doesn't exist
if not exist "%HOOKS_DIR%" mkdir "%HOOKS_DIR%"

REM Copy hook files
copy /Y "%SCRIPT_DIR%pre-commit" "%HOOKS_DIR%\pre-commit" >nul
copy /Y "%SCRIPT_DIR%commit-msg" "%HOOKS_DIR%\commit-msg" >nul
copy /Y "%SCRIPT_DIR%pre-push" "%HOOKS_DIR%\pre-push" >nul
copy /Y "%SCRIPT_DIR%pre-rebase" "%HOOKS_DIR%\pre-rebase" >nul

REM Make files executable (Windows doesn't need this, but keeping for consistency)
echo.
echo ✅ Git hooks installed successfully!
echo.
echo Installed hooks:
echo - pre-commit: Prevents direct commits to main/develop branches
echo - commit-msg: Enforces commit message format rules
echo - pre-push: Prevents pushes to main/develop branches and force pushes
echo.
pause
