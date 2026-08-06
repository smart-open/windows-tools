@echo off
setlocal enabledelayedexpansion

:: Set UTF-8 encoding for Chinese support
chcp 65001 >nul
cls

echo ============================================
echo    Windows 11 Disk Cleanup Tool
echo ============================================
echo.

:: Admin check
NET SESSION >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Starting cleanup process...
echo.

:: Get free space before
for /f %%a in ('powershell -Command "(Get-PSDrive C).Free"') do set before=%%a
echo Free space before cleanup: !before! bytes

:: Clean 1: System temp
echo [1/15] Cleaning system temporary files...
if exist "%windir%\Temp" (
    cd /d "%windir%\Temp"
    del /f /q *.* 2>nul
    for /d %%d in (*) do rd /s /q "%%d" 2>nul
)

:: Clean 2: User temp
echo [2/15] Cleaning user temporary files...
if exist "%temp%" (
    cd /d "%temp%"
    del /f /q *.* 2>nul
    for /d %%d in (*) do rd /s /q "%%d" 2>nul
)

:: Clean 3: Windows Update cache
echo [3/15] Cleaning Windows Update cache...
sc stop wuauserv >nul 2>&1
if exist "%windir%\SoftwareDistribution\Download" (
    takeown /f "%windir%\SoftwareDistribution\Download" /r /d y >nul 2>&1
    icacls "%windir%\SoftwareDistribution\Download" /grant administrators:F /t >nul 2>&1
    rd /s /q "%windir%\SoftwareDistribution\Download" 2>nul
    mkdir "%windir%\SoftwareDistribution\Download" 2>nul
)
sc start wuauserv >nul 2>&1

:: Clean 4: Thumbnail cache
echo [4/15] Cleaning thumbnail cache...
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\iconcache_*.db" 2>nul

:: Clean 5: Recycle bin
echo [5/15] Emptying recycle bin...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" 2>nul

:: Clean 6: Windows.old
echo [6/15] Cleaning Windows.old folder...
if exist "%windir%\..\Windows.old" (
    takeown /f "%windir%\..\Windows.old" /r /d y >nul 2>&1
    icacls "%windir%\..\Windows.old" /grant administrators:F /t >nul 2>&1
    rd /s /q "%windir%\..\Windows.old" 2>nul
)

:: Clean 7: Prefetch
echo [7/15] Cleaning Windows prefetch files...
del /f /q "%windir%\Prefetch\*.pf" 2>nul

:: Clean 8: Browser cache - Chrome
echo [8/15] Cleaning Chrome browser cache...
if exist "%localappdata%\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache" 2>nul
    rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Code Cache" 2>nul
    rd /s /q "%localappdata%\Google\Chrome\User Data\Default\GPUCache" 2>nul
)

:: Clean 9: Browser cache - Edge
echo [9/15] Cleaning Edge browser cache...
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" 2>nul
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Code Cache" 2>nul
)

:: Clean 10: Dev tools cache
echo [10/15] Cleaning development tools cache...
if exist "%appdata%\npm-cache" rd /s /q "%appdata%\npm-cache" 2>nul
if exist "%localappdata%\pip\cache" rd /s /q "%localappdata%\pip\cache" 2>nul

:: Clean 11: Codex cache
echo [11/15] Cleaning Codex cache and temp files...
if exist "%userprofile%\.codex" (
    rd /s /q "%userprofile%\.codex\cache" 2>nul
    rd /s /q "%userprofile%\.codex\logs" 2>nul
    rd /s /q "%userprofile%\.codex\temp" 2>nul
)
if exist "%localappdata%\Codex" (
    rd /s /q "%localappdata%\Codex\Cache" 2>nul
    rd /s /q "%localappdata%\Codex\Logs" 2>nul
)

:: Clean 12: Claude Code cache
echo [12/15] Cleaning Claude Code cache...
if exist "%userprofile%\.claude" (
    rd /s /q "%userprofile%\.claude\cache" 2>nul
    rd /s /q "%userprofile%\.claude\logs" 2>nul
)
if exist "%localappdata%\Claude" (
    rd /s /q "%localappdata%\Claude\Cache" 2>nul
    rd /s /q "%localappdata%\Claude\Logs" 2>nul
)

:: Clean 13: WorkBuddy cache
echo [13/15] Cleaning WorkBuddy cache...
if exist "%userprofile%\.workbuddy" (
    rd /s /q "%userprofile%\.workbuddy\cache" 2>nul
    rd /s /q "%userprofile%\.workbuddy\logs" 2>nul
    rd /s /q "%userprofile%\.workbuddy\temp" 2>nul
)
if exist "%localappdata%\WorkBuddy" (
    rd /s /q "%localappdata%\WorkBuddy\Cache" 2>nul
    rd /s /q "%localappdata%\WorkBuddy\Logs" 2>nul
)

:: Clean 14: TRAE cache
echo [14/15] Cleaning TRAE cache files...
if exist "%userprofile%\.trae-cn" (
    rd /s /q "%userprofile%\.trae-cn\cache" 2>nul
    rd /s /q "%userprofile%\.trae-cn\logs" 2>nul
    rd /s /q "%userprofile%\.trae-cn\temp" 2>nul
    for /d %%d in ("%userprofile%\.trae-cn\work\*") do (
        if exist "%%d\temp" rd /s /q "%%d\temp" 2>nul
        if exist "%%d\cache" rd /s /q "%%d\cache" 2>nul
    )
)
if exist "%userprofile%\.trae" (
    rd /s /q "%userprofile%\.trae\cache" 2>nul
    rd /s /q "%userprofile%\.trae\logs" 2>nul
)
if exist "%localappdata%\TRAE" (
    rd /s /q "%localappdata%\TRAE\Cache" 2>nul
    rd /s /q "%localappdata%\TRAE\Logs" 2>nul
)

:: Clean 15: TRAE Work cache
echo [15/15] Cleaning TRAE Work workspace cache...
if exist "%userprofile%\.trae-work" (
    rd /s /q "%userprofile%\.trae-work\cache" 2>nul
    rd /s /q "%userprofile%\.trae-work\logs" 2>nul
    rd /s /q "%userprofile%\.trae-work\temp" 2>nul
)
if exist "%userprofile%\.trae-cn\work" (
    for /d %%d in ("%userprofile%\.trae-cn\work\*") do (
        if exist "%%d\.temp" rd /s /q "%%d\.temp" 2>nul
        if exist "%%d\.cache" rd /s /q "%%d\.cache" 2>nul
        if exist "%%d\tmp" rd /s /q "%%d\tmp" 2>nul
    )
)

:: Error reports and crash dumps
echo Cleaning error reports and crash dumps...
if exist "%localappdata%\Microsoft\Windows\WER" (
    rd /s /q "%localappdata%\Microsoft\Windows\WER\ReportArchive" 2>nul
    rd /s /q "%localappdata%\Microsoft\Windows\WER\ReportQueue" 2>nul
)
if exist "%localappdata%\CrashDumps" del /f /q "%localappdata%\CrashDumps\*.dmp" 2>nul
if exist "%windir%\Memory.dmp" del /f /q "%windir%\Memory.dmp" 2>nul

:: Delivery optimization cache
echo Cleaning delivery optimization cache...
if exist "%localappdata%\Microsoft\Windows\DeliveryOptimization\Cache" (
    rd /s /q "%localappdata%\Microsoft\Windows\DeliveryOptimization\Cache" 2>nul
)

:: Get free space after
for /f %%a in ('powershell -Command "(Get-PSDrive C).Free"') do set after=%%a

:: Calculate freed space
set /a freed=!after! - !before!

:: Convert to readable format
for /f %%a in ('powershell -Command "[math]::Round(!freed! / 1MB, 2)"') do set mb=%%a
for /f %%a in ('powershell -Command "[math]::Round(!freed! / 1GB, 2)"') do set gb=%%a

echo.
echo ============================================
echo Cleanup Completed!
echo ============================================
echo Freed space: !mb! MB (!gb! GB)
echo ============================================
echo.

echo Press any key to exit...
pause >nul
exit /b
