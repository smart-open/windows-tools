@echo off
chcp 65001 >nul
cls
:: ============================================================================
:: Windows系统清理工具  
:: 作者: Windows优化助手    
:: 创建日期：2025-10-17 
:: 功能描述：清理系统临时文件、浏览器缓存、系统日志等11项内容   
:: 系统要求：Windows 10/11  
:: 使用说明：以管理员权限运行，按提示操作   
:: 日志路径：与脚本同目录下的clean_log.txt  
:: ============================================================================

:: 创建日志文件 
set "log_file=%~dp0\clean_log.txt"
echo 清理工具日志 > "%log_file%"
echo 开始时间: %date% %time% >> "%log_file%"

:: 管理员权限检查
NET SESSION >nul 2>&1
if %errorLevel% NEQ 0 (
    echo 需要管理员权限，请点击"是"确认...  
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo 已获取管理员权限 >> "%log_file%"

:: 用户确认
echo.
echo ========================================
echo    Windows系统清理工具 
echo ========================================
echo 本工具将清理:  
echo    1. 系统临时文件 
echo    2. 用户临时文件 
echo    3. 浏览器缓存   
echo    4. Windows更新缓存  
echo    5. 系统日志 
echo    6. 图形缓存 
echo    7. 回收站清理   
echo    8. 系统休眠文件清理 
echo    9. Java缓存清理 
echo    10. Windows预取文件清理 
echo    11. 其他数据清理
echo    12. 系统信息收集    
echo ========================================
echo.

set /p confirm=确认执行清理？(Y/N):
if /i not "%confirm%"=="Y" (
    echo 用户取消，退出脚本 
    timeout /t 3 >nul
    exit /b
)

:: 清理模块1: 系统临时文件  
echo [LOG] 进入模块1: 系统临时文件 >> "%log_file%"
echo 开始清理模块1: 系统临时文件    
echo [LOG] 开始清理模块1: 系统临时文件 >> "%log_file%"

:: 使用最简单的命令 
cd /d "%windir%\Temp" 2>nul
if %errorLevel% equ 0 (
    echo 正在删除系统临时文件...
    echo [LOG] 正在删除系统临时文件... >> "%log_file%"
    dir /b *.* >> "%log_file%"
    del /f /q *.* 2>&1 >> "%log_file%"
    echo [LOG] 正在删除系统临时文件夹... >> "%log_file%"
    for /d %%d in (*) do (
        echo [LOG] 删除目录: %%d >> "%log_file%"
        rmdir /s /q "%%d" 2>&1 >> "%log_file%"
    )
) else (
    echo [LOG] 无法访问系统临时目录 >> "%log_file%"
)

echo [LOG] 模块1完成，准备进入模块2 >> "%log_file%"
echo 模块1完成...   

:: 清理模块2: 用户临时文件  
echo [LOG] 进入模块2: 用户临时文件 >> "%log_file%"
echo 开始清理模块2: 用户临时文件    

set "user_temp=%temp%"
echo [LOG] 用户临时目录路径: %user_temp% >> "%log_file%"
cd /d "%user_temp%" 2>nul
if %errorLevel% equ 0 (
    echo 正在删除用户临时文件...    
    echo [LOG] 正在删除用户临时文件... >> "%log_file%"
    del /f /q *.* 2>&1 >> "%log_file%"
    echo [LOG] 正在删除用户临时文件夹... >> "%log_file%"
    for /d %%d in (*) do (
        echo [LOG] 删除目录: %%d >> "%log_file%"
        rmdir /s /q "%%d" 2>&1 >> "%log_file%"
    )
) else (
    echo [LOG] 无法访问用户临时目录 >> "%log_file%"
)

echo [LOG] 模块2完成 >> "%log_file%"
echo 模块2完成...   

:: 清理模块3: 浏览器缓存     
echo [LOG] 进入模块3: 浏览器缓存 >> "%log_file%"
echo 开始清理模块3: 浏览器缓存  

:: Chrome缓存清理   
if exist "%localappdata%\Google\Chrome\User Data\" (
    echo 正在清理Chrome缓存...  
    echo [LOG] 清理Chrome缓存... >> "%log_file%"
    rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache" 2>nul
    mkdir "%localappdata%\Google\Chrome\User Data\Default\Cache" 2>nul
)

:: Edge缓存清理 
if exist "%localappdata%\Microsoft\Edge\User Data\" (
    echo 正在清理Edge缓存...    
    echo [LOG] 清理Edge缓存... >> "%log_file%"
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" 2>nul
    mkdir "%localappdata%\Microsoft\Edge\User Data\Default\Cache" 2>nul
)

echo [LOG] 模块3完成 >> "%log_file%"
echo 模块3完成...   

:: 清理模块4: Windows更新缓存   
echo [LOG] 进入模块4: Windows更新缓存 >> "%log_file%"
echo 开始清理模块4: Windows更新缓存 

:: 检查Windows更新服务状态
sc query wuauserv | findstr "RUNNING" >nul
if %errorLevel% equ 0 (
    echo Windows更新服务正在运行，正在禁用服务... 
    echo [LOG] Windows更新服务正在运行，正在禁用服务... >> "%log_file%"
    net stop wuauserv 2>nul
    if %errorLevel% equ 0 (
        echo [LOG] Windows更新服务已停止 >> "%log_file%"
    ) else (
        echo [LOG] 停止Windows更新服务失败 >> "%log_file%"
    )
) else (
    echo Windows更新服务已关闭，直接清理缓存... 
    echo [LOG] Windows更新服务已关闭，直接清理缓存... >> "%log_file%"
)

if exist "%windir%\SoftwareDistribution\Download" (
    echo 正在清理更新缓存...    
    echo [LOG] 清理更新缓存... >> "%log_file%"
    rd /s /q "%windir%\SoftwareDistribution\Download" 2>nul
    mkdir "%windir%\SoftwareDistribution\Download" 2>nul
)

echo [LOG] 模块4完成 >> "%log_file%"
echo 模块4完成...   

:: 清理模块5: 系统日志      
echo [LOG] 进入模块5: 系统日志 >> "%log_file%"
echo 开始清理模块5: 系统日志    

echo [LOG] 开始清理系统日志... >> "%log_file%"
for /f "tokens=*" %%i in ('wevtutil el') do (
    echo [LOG] 清理日志: %%i >> "%log_file%"
    wevtutil cl "%%i" 2>nul
)

echo [LOG] 模块5完成 >> "%log_file%"
echo 模块5完成...   

:: 清理模块6: 图形缓存  
echo [LOG] 进入模块6: 图形缓存 >> "%log_file%"
echo 开始清理模块6: 图形缓存    

echo 正在清理缩略图缓存...  
echo [LOG] 清理缩略图缓存... >> "%log_file%"
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul

echo [LOG] 模块6完成 >> "%log_file%"
echo 模块6完成...   

:: 清理模块7: 回收站清理    
echo [LOG] 进入模块7: 回收站清理 >> "%log_file%"
echo 开始清理模块7: 回收站清理  

echo 正在清理回收站...  
echo [LOG] 开始清理回收站... >> "%log_file%"
:: 使用PowerShell安全清理回收站
powershell -Command "Clear-RecycleBin -Force" 2>nul
if %errorLevel% equ 0 (
    echo [LOG] 回收站清理成功 >> "%log_file%"
) else (
    echo [LOG] 回收站清理失败，可能无权限或为空 >> "%log_file%"
)

echo [LOG] 模块7完成 >> "%log_file%"
echo 模块7完成...   

:: 清理模块8: 系统休眠文件清理  
echo [LOG] 进入模块8: 系统休眠文件清理 >> "%log_file%"
echo 开始清理模块8: 系统休眠文件清理    

echo 正在清理系统休眠文件...    
echo [LOG] 清理系统休眠文件... >> "%log_file%"
:: 清理休眠文件（如果存在） 
powercfg -h off >nul 2>&1
if %errorLevel% equ 0 (
    echo [LOG] 休眠文件已禁用 >> "%log_file%"
    :: 重新启用休眠（可选） 
    powercfg -h on >nul 2>&1
    echo [LOG] 休眠功能已重新启用 >> "%log_file%"
) else (
    echo [LOG] 休眠文件清理失败，可能无权限 >> "%log_file%"
)

echo [LOG] 模块8完成 >> "%log_file%"
echo 模块8完成...   

:: 清理模块9: Java缓存清理  
echo [LOG] 进入模块9: Java缓存清理 >> "%log_file%"
echo 开始清理模块9: Java缓存清理    

echo 正在清理Java缓存...    
echo [LOG] 清理Java缓存... >> "%log_file%"

:: 查找并清理Java缓存目录（如果存在）   
if exist "%localappdata%\Low\Sun\Java\Deployment\cache" (
    echo [LOG] 清理用户Java缓存... >> "%log_file%"
    rd /s /q "%localappdata%\Low\Sun\Java\Deployment\cache" 2>nul
    mkdir "%localappdata%\Low\Sun\Java\Deployment\cache" 2>nul
)

:: 清理JRE缓存（如果存在）  
for /d %%j in ("%ProgramFiles%\Java\jre*", "%ProgramFiles(x86)%\Java\jre*") do (
    if exist "%%j\lib\ext" (
        echo [LOG] 清理JRE缓存: %%j >> "%log_file%"
        del /f /q "%%j\lib\ext\*.jar" 2>nul
    )
)

echo [LOG] 模块9完成 >> "%log_file%"
echo 模块9完成...   

:: 清理模块10: Windows预取文件清理  
echo [LOG] 进入模块10: Windows预取文件清理 >> "%log_file%"
echo 开始清理模块10: Windows预取文件清理    

echo 正在清理Windows预取文件... 
echo [LOG] 清理Windows预取文件... >> "%log_file%"

:: 清理Windows预取文件  
if exist "%windir%\Prefetch" (
    cd /d "%windir%\Prefetch" 2>nul
    if %errorLevel% equ 0 (
        del /f /q *.pf 2>nul
        echo [LOG] 预取文件清理完成 >> "%log_file%"
    ) else (
        echo [LOG] 无法访问预取目录 >> "%log_file%"
    )
)

echo [LOG] 模块10完成 >> "%log_file%"
echo 模块10完成...  

:: 清理模块11: 其他数据清理 
echo [LOG] 进入模块11: 其他数据清理 >> "%log_file%"
echo 开始清理其他数据...    

:: 清理Maven本地仓库缓存    
if exist "%userprofile%\.m2\repository" (
    echo 正在清理Maven本地仓库缓存...
    echo [LOG] 清理Maven本地仓库缓存... >> "%log_file%"
    for /d %%d in ("%userprofile%\.m2\repository\*\*") do (
        if exist "%%d" (
            echo [LOG] 删除Maven缓存目录: %%d >> "%log_file%"
            rd /s /q "%%d" 2>nul
        )
    )
)

:: 清理Windows错误报告  
echo 正在清理Windows错误报告... 
echo [LOG] 清理Windows错误报告... >> "%log_file%"
if exist "%localappdata%\Microsoft\Windows\WER\ReportArchive" (
    rd /s /q "%localappdata%\Microsoft\Windows\WER\ReportArchive" 2>nul
    mkdir "%localappdata%\Microsoft\Windows\WER\ReportArchive" 2>nul
)

:: 清理临时备份文件 
echo 正在清理临时备份文件...    
echo [LOG] 清理临时备份文件... >> "%log_file%"
for /r "%userprofile%\Downloads" %%f in (*.bak, *.tmp, *.old, *_bak.*) do (
    if exist "%%f" (
        echo [LOG] 删除备份文件: %%f >> "%log_file%"
        del /f /q "%%f" 2>nul
    )
)

:: 清理应用程序缓存 
echo 正在清理应用程序缓存...    
echo [LOG] 清理应用程序缓存... >> "%log_file%"

:: 清理Electron应用缓存 
if exist "%appdata%\Electron" (
    rd /s /q "%appdata%\Electron" 2>nul
)

:: 清理npm缓存  
if exist "%appdata%\npm-cache" (
    rd /s /q "%appdata%\npm-cache" 2>nul
)

:: 清理Chrome扩展缓存   
if exist "%localappdata%\Google\Chrome\User Data\Default\ExtensionsCache" (
    rd /s /q "%localappdata%\Google\Chrome\User Data\Default\ExtensionsCache" 2>nul
)

echo [LOG] 模块11完成 >> "%log_file%"
echo 模块11完成...      

:: 清理模块12: 系统信息收集 
echo [LOG] 进入模块12: 系统信息收集 >> "%log_file%"
echo 开始收集系统信息...        

echo [LOG] 收集系统信息... >> "%log_file%"

:: 使用更轻量的命令收集磁盘空间信息 
echo [LOG] 磁盘空间信息: >> "%log_file%"
wmic logicaldisk where drivetype=3 get caption,freespace,size >> "%log_file%"

:: 收集内存使用情况 
echo [LOG] 内存使用情况: >> "%log_file%"
systeminfo | findstr "物理内存" >> "%log_file%" 2>nul

echo [LOG] 模块12完成 >> "%log_file%"
echo 模块12完成...      

:: 完成报告 
echo [LOG] 开始生成完成报告 >> "%log_file%"
echo.
echo ========================================
echo 清理操作完成！     
echo 完成时间: %date% %time% >> "%log_file%"
echo ========================================
echo 详细日志已保存到: %log_file%
echo [LOG] 清理操作完全结束 >> "%log_file%"

:: 等待用户确认后退出   
echo.  
echo 按任意键退出...    
pause >nul
exit /b