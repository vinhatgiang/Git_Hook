@echo off
setlocal enabledelayedexpansion

REM Script to install Git hooks
REM Platform: Windows
REM Purpose: Install and configure Git hooks with permissions

echo ╔═══════════════════════════════════════╗
echo ║        Git Hooks Installer           ║
echo ╚═══════════════════════════════════════╝

REM Get the directory of this script
set "SCRIPT_DIR=%~dp0"

REM Check if we're in a Git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Not a Git repository
    echo Please run this script from a Git repository root
    pause
    exit /b 1
)

REM Get the git hooks directory
set "HOOKS_DIR=%SCRIPT_DIR%..\.git\hooks"

REM Create hooks directory if it doesn't exist
if not exist "%HOOKS_DIR%" mkdir "%HOOKS_DIR%"

REM Check if all required hooks exist
set "MISSING_FILES="
if not exist "%SCRIPT_DIR%\pre-commit" set "MISSING_FILES=!MISSING_FILES! pre-commit"
if not exist "%SCRIPT_DIR%\commit-msg" set "MISSING_FILES=!MISSING_FILES! commit-msg"
if not exist "%SCRIPT_DIR%\pre-push" set "MISSING_FILES=!MISSING_FILES! pre-push"
if not exist "%SCRIPT_DIR%\pre-rebase" set "MISSING_FILES=!MISSING_FILES! pre-rebase"

if not "!MISSING_FILES!"=="" (
    echo ❌ ERROR: Missing required hook files:!MISSING_FILES!
    echo Please ensure all hook files are present in %SCRIPT_DIR%
    pause
    exit /b 1
)

REM Create backup of existing hooks
if exist "%HOOKS_DIR%\*" (
    set "BACKUP_DIR=%HOOKS_DIR%-backup-%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%"
    set "BACKUP_DIR=!BACKUP_DIR: =0!"
    echo 📦 Creating backup of existing hooks in !BACKUP_DIR!...
    mkdir "!BACKUP_DIR!" 2>nul
    move "%HOOKS_DIR%\*" "!BACKUP_DIR!\" >nul 2>&1
)

echo 🔧 Installing Git hooks...

REM Copy hook files with error checking
set "FAILED="
copy /Y "%SCRIPT_DIR%\pre-commit" "%HOOKS_DIR%\pre-commit" >nul || set "FAILED=!FAILED! pre-commit"
copy /Y "%SCRIPT_DIR%\commit-msg" "%HOOKS_DIR%\commit-msg" >nul || set "FAILED=!FAILED! commit-msg"
copy /Y "%SCRIPT_DIR%\pre-push" "%HOOKS_DIR%\pre-push" >nul || set "FAILED=!FAILED! pre-push"
copy /Y "%SCRIPT_DIR%\pre-rebase" "%HOOKS_DIR%\pre-rebase" >nul || set "FAILED=!FAILED! pre-rebase"

if not "!FAILED!"=="" (
    echo ❌ ERROR: Failed to install hooks:!FAILED!
    pause
    exit /b 1
)

echo.
echo ✅ Git hooks installed successfully!
echo.
echo 📋 Installed hooks:
echo • pre-commit  : Prevents commits to protected branches
echo • commit-msg  : Enforces commit message format rules
echo • pre-push    : Prevents pushes to protected branches
echo • pre-rebase  : Prevents rebase operations
echo.
echo 🛡️  Active protection rules:
echo • No direct commits to main/develop branches
echo • No pushes to protected branches
echo • No force pushes
echo • No rebase operations
echo • Commit message format validation
echo.
echo 💡 To create a new feature:
echo   git checkout -b feature/your-feature
echo   git add .
echo   git commit -m "type: your message"
echo   git push origin feature/your-feature
echo.
pause
