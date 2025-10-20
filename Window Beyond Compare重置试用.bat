@echo off
:: 设置UTF-8编码
chcp 65001 >nul
cls
:: ============================================================================
:: Beyond Compare 重置试用工具  
:: 作者：Windows优化助手        
:: 创建日期：2025-10-17 
:: 功能描述：重置 Beyond Compare 4.x/5.x 试用期限   
:: 系统要求：Windows 10/11  
:: 使用说明：以管理员权限运行即可重置试用期 
:: ============================================================================

:: 设置变量存储BCompare路径
set "bcompare_path="

:: 删除 Beyond Compare 试用标记（支持 4.x/5.x）
reg delete "HKEY_CURRENT_USER\Software\Scooter Software\Beyond Compare 5" /v CacheID /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Scooter Software\Beyond Compare 4" /v CacheID /f >nul 2>&1

echo 正在搜索Beyond Compare安装路径...

:: 方法1: 搜索常见安装路径
:: 检查64位默认路径
if exist "C:\Program Files\Beyond Compare 5\BCompare.exe" (
    set "bcompare_path=C:\Program Files\Beyond Compare 5\BCompare.exe"
    echo 找到Beyond Compare 5 64位路径
)

:: 检查32位默认路径
if exist "C:\Program Files (x86)\Beyond Compare 5\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=C:\Program Files (x86)\Beyond Compare 5\BCompare.exe"
        echo 找到Beyond Compare 5 32位路径
    )
)

:: 检查Beyond Compare 4的路径
if exist "C:\Program Files\Beyond Compare 4\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=C:\Program Files\Beyond Compare 4\BCompare.exe"
        echo 找到Beyond Compare 4 64位路径
    )
)

if exist "C:\Program Files (x86)\Beyond Compare 4\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=C:\Program Files (x86)\Beyond Compare 4\BCompare.exe"
        echo 找到Beyond Compare 4 32位路径
    )
)

:: 检查D盘安装路径
if exist "D:\Program Files\Beyond Compare 5\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=D:\Program Files\Beyond Compare 5\BCompare.exe"
        echo 找到Beyond Compare 5 D盘64位路径
    )
)

if exist "D:\Program Files (x86)\Beyond Compare 5\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=D:\Program Files (x86)\Beyond Compare 5\BCompare.exe"
        echo 找到Beyond Compare 5 D盘32位路径
    )
)

if exist "D:\Program Files\Beyond Compare 4\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=D:\Program Files\Beyond Compare 4\BCompare.exe"
        echo 找到Beyond Compare 4 D盘64位路径
    )
)

if exist "D:\Program Files (x86)\Beyond Compare 4\BCompare.exe" (
    if not defined bcompare_path (
        set "bcompare_path=D:\Program Files (x86)\Beyond Compare 4\BCompare.exe"
        echo 找到Beyond Compare 4 D盘32位路径
    )
)

:: 方法2: 搜索桌面快捷方式
if not defined bcompare_path (
    echo 检查桌面快捷方式...
    set "desktop_dir=%USERPROFILE%\Desktop"
    
    :: 先检查是否有Beyond Compare快捷方式
    dir "%desktop_dir%\Beyond Compare*.lnk" >nul 2>nul
    if %errorlevel% equ 0 (
        echo 找到Beyond Compare快捷方式
        
        :: 使用PowerShell获取快捷方式目标路径
        powershell -Command "try { $wsh = New-Object -ComObject WScript.Shell; $shortcut = $wsh.CreateShortcut('%desktop_dir%\Beyond Compare*.lnk'); $shortcut.TargetPath } catch { }" > bc_path.txt 2>nul
        
        :: 读取结果
        for /f "usebackq delims=" %%i in ("bc_path.txt") do (
            if exist "%%i" (
                if "%%~xi"==".exe" (
                    set "bcompare_path=%%i"
                    echo 从快捷方式获取路径成功
                )
            )
        )
        del bc_path.txt >nul 2>nul
    )
)

:: 启动Beyond Compare（如果找到路径）
if defined bcompare_path (
    echo 找到Beyond Compare路径: %bcompare_path%
    echo 成功: 试用期已重置！软件启动中...
    start "" "%bcompare_path%"
) else (
    echo 错误: 未找到Beyond Compare程序！
    echo 提示: 请确认Beyond Compare已正确安装，或手动启动程序。
)

pause