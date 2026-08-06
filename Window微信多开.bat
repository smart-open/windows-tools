@echo off
chcp 65001 >nul
cls
:: 启用延迟变量展开以避免变量比较问题
setlocal enabledelayedexpansion

:: ============================================================================
:: 微信多开工具 v1.0    
:: 作者：Windows优化助手    
:: 创建日期：2025-10-17 
:: 功能描述：支持自定义微信多开数量和自动搜索安装路径   
:: 系统要求：Windows 10/11  
:: ============================================================================

:: 设置默认值   
set "default_count=2"
set "wechat_path="

:: 显示脚本信息 
echo ===========================
echo 微信多开工具 v1.0  
echo 1. 自定义微信多开数量  
echo 2. 自动搜索微信安装路径    
echo ===========================
echo.

:: 检查微信进程是否正在运行 
echo 检查进程...    

:: 使用更精确的进程匹配，并添加调试信息
set "wechat_running=false"
tasklist | findstr /i "WeChatAppEx.exe" > wechat_process.txt 2>nul
for /f "tokens=1" %%p in (wechat_process.txt) do (
    if /i "%%p"=="WeChatAppEx.exe" (
        set "wechat_running=true"
        echo 发现微信进程：%%p
    )
)
del wechat_process.txt >nul 2>nul

if !wechat_running!==true (
    echo.
    echo 微信已在运行！ 
    echo 多开需要先退出当前微信。   
    set "confirm=2"
    set /p "confirm=继续操作？(1-退出/2-继续，默认2): " 
    
    :: 去除可能的前导和尾随空格
    set "confirm=!confirm: =!"
    
    echo 您输入的值是：[!confirm!]
    
    :: 使用更安全的比较方式
    if /i "!confirm!"=="1" (
        echo 操作已取消！   
        pause
        exit /b 0
    )
    
    echo 请手动关闭微信后继续...    
    pause

    :: 暂停5秒钟，等待微信进程结束
    timeout /t 5 /nobreak >nul

    :: 再次检查微信是否关闭
    echo.
    echo 再次检查进程...    
    
    set "wechat_running=false"
    tasklist | findstr /i "WeChatAppEx.exe" > wechat_process.txt 2>nul
    for /f "tokens=1" %%p in (wechat_process.txt) do (
        if /i "%%p"=="WeChatAppEx.exe" (
            set "wechat_running=true"
            echo 仍然发现微信进程：%%p
        )
    )
    del wechat_process.txt >nul 2>nul
    
    if !wechat_running!==true (
        echo 错误：微信仍在运行！   
        echo 提示：某些情况下微信可能有后台进程残留，请尝试以下方法：
        echo 1. 打开任务管理器，手动结束所有WeChat.exe进程
        echo 2. 或按Ctrl+C结束脚本，稍后重试
        pause
        exit /b 1
    ) else (
        echo 微信已成功关闭！
    )
)

:: 自动搜索微信安装路径
echo 正在搜索微信安装路径...

:: 方法1: 搜索常见安装路径
if exist "C:\Program Files\Tencent\Weixin\Weixin.exe" (
    set "wechat_path=C:\Program Files\Tencent\Weixin\Weixin.exe"
    echo 找到64位安装路径   
)

if exist "C:\Program Files (x86)\Tencent\Weixin\Weixin.exe" (
    if not defined wechat_path (
        set "wechat_path=C:\Program Files (x86)\Tencent\Weixin\Weixin.exe"
        echo 找到32位安装路径   
    )
)

if exist "D:\Program Files\Tencent\Weixin\Weixin.exe" (
    if not defined wechat_path (
        set "wechat_path=D:\Program Files\Tencent\Weixin\Weixin.exe"
        echo 找到D盘安装路径    
    )
)

if exist "D:\Program Files (x86)\Tencent\Weixin\Weixin.exe" (
    if not defined wechat_path (
        set "wechat_path=D:\Program Files (x86)\Tencent\Weixin\Weixin.exe"
        echo 找到D盘32位安装路径    
    )
)

:: 添加对C盘根目录Weixin文件夹的支持
if exist "C:\Weixin\Weixin.exe" (
    if not defined wechat_path (
        set "wechat_path=C:\Weixin\Weixin.exe"
        echo 找到C盘根目录Weixin安装路径    
    )
)

:: 添加对D盘根目录Weixin文件夹的支持
if exist "D:\Weixin\Weixin.exe" (
    if not defined wechat_path (
        set "wechat_path=D:\Weixin\Weixin.exe"
        echo 找到D盘根目录Weixin安装路径    
    )
)

:: 方法2: 搜索桌面快捷方式 - 使用更安全的实现
if not defined wechat_path (
    echo 检查桌面快捷方式...    
    set "desktop_dir=%USERPROFILE%\Desktop"
    set "public_desktop=C:\Users\Public\Desktop"
    
    :: 先搜索当前用户桌面
    echo 搜索当前用户桌面...
    dir "%desktop_dir%\微信*.lnk" >nul 2>nul
    if %errorlevel% equ 0 (
        echo 找到当前用户桌面快捷方式   
        
        :: 使用for循环处理所有可能的微信快捷方式
        for %%l in ("%desktop_dir%\微信*.lnk") do (
            :: 使用PowerShell获取快捷方式目标路径
            powershell -Command "try { $wsh = New-Object -ComObject WScript.Shell; $shortcut = $wsh.CreateShortcut('%%l'); $shortcut.TargetPath } catch { }" > wxp_path.txt 2>nul
            
            :: 读取结果
            for /f "usebackq delims=" %%i in ("wxp_path.txt") do (
                if exist "%%i" (
                    if "%%~xi"==".exe" (
                        set "wechat_path=%%i"
                        echo 从当前用户桌面快捷方式获取路径成功 
                        goto :shortcut_found  :: 找到后跳出循环
                    )
                )
            )
            del wxp_path.txt >nul 2>nul
        )
    )
    
    :: 如果当前用户桌面没找到，再搜索公用桌面
    if not defined wechat_path (
        echo 搜索公用桌面...
        dir "%public_desktop%\微信*.lnk" >nul 2>nul
        if %errorlevel% equ 0 (
            echo 找到公用桌面快捷方式   
            
            :: 使用for循环处理所有可能的微信快捷方式
            for %%l in ("%public_desktop%\微信*.lnk") do (
                :: 使用PowerShell获取快捷方式目标路径
                powershell -Command "try { $wsh = New-Object -ComObject WScript.Shell; $shortcut = $wsh.CreateShortcut('%%l'); $shortcut.TargetPath } catch { }" > wxp_path.txt 2>nul
                
                :: 读取结果
                for /f "usebackq delims=" %%i in ("wxp_path.txt") do (
                    if exist "%%i" (
                        if "%%~xi"==".exe" (
                            set "wechat_path=%%i"
                            echo 从公用桌面快捷方式获取路径成功 
                            goto :shortcut_found  :: 找到后跳出循环
                        )
                    )
                )
                del wxp_path.txt >nul 2>nul
            )
        )
    )
    
    :shortcut_found
)

:: 显示找到的路径
if defined wechat_path (
    echo 找到微信路径: %wechat_path%    
) else (
    echo 错误：未找到微信程序！ 
    echo 请确认微信已正确安装。 
    pause
    exit /b 1
)

:: 获取多开数量
echo.
set "open_count="
set /p "open_count=请输入多开数量 (默认2): " 

:: 如果用户没有输入，使用默认值
if "%open_count%"=="" set "open_count=%default_count%"

:: 简单的数字验证
set "valid=true"
set "open_count=!open_count: =!"
echo !open_count!^|findstr /r "^[0-9][0-9]*$" >nul || set "valid=false"

if "!valid!"=="false" (
    echo 错误：请输入有效数字！ 
    pause
    exit /b 1
)

:: 启动微信实例
echo.
echo 正在启动 %open_count% 个微信...    

for /l %%i in (1,1,%open_count%) do (
    echo 启动第 %%i 个微信...   
    start "微信%%i" "%wechat_path%"
)

echo.
echo 所有微信已启动完成！   
pause
exit /b 0