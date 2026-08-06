@echo off
chcp 65001 >nul
cls
setlocal enabledelayedexpansion

:: ============================================================================
:: 微信多开工具 v2.0
:: 功能：支持自定义多开数量，自动搜索安装路径
:: 使用：先关闭微信，然后运行本脚本
:: ============================================================================

title 微信多开工具

echo ============================================
echo        微信多开工具 v2.0
echo ============================================
echo.

:: 检查微信进程
echo [1/4] 检查微信进程...
tasklist | findstr /i "WeChat.exe WeChatAppEx.exe" >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo 警告：检测到微信正在运行！
    echo 多开需要先关闭所有微信进程
    echo.
    set /p "confirm=是否继续？(Y/N): "
    if /i not "!confirm!"=="Y" (
        echo 操作已取消
        pause
        exit /b
    )
    echo.
    echo 请手动关闭微信后按任意键继续...
    pause >nul
    
    :: 再次检查
    tasklist | findstr /i "WeChat.exe WeChatAppEx.exe" >nul 2>&1
    if %errorlevel% equ 0 (
        echo 错误：微信仍在运行，请关闭后重试！
        pause
        exit /b 1
    )
    echo 微信已关闭
) else (
    echo 未检测到运行中的微信
)
echo.

:: 搜索微信安装路径
echo [2/4] 正在搜索微信安装路径...
set "wechat_path="
set "drives=C D"
set "archs=Program Files Program Files (x86)"

for %%d in (%drives%) do (
    for %%a in (%archs%) do (
        if not defined wechat_path (
            if exist "%%d:\%%a\Tencent\Weixin\Weixin.exe" (
                set "wechat_path=%%d:\%%a\Tencent\Weixin\Weixin.exe"
                echo 找到标准安装路径
            )
        )
    )
)

:: 搜索根目录安装
for %%d in (%drives%) do (
    if not defined wechat_path (
        if exist "%%d:\Weixin\Weixin.exe" (
            set "wechat_path=%%d:\Weixin\Weixin.exe"
            echo 找到根目录安装路径
        )
    )
)

:: 从桌面快捷方式搜索
if not defined wechat_path (
    for %%d in ("%USERPROFILE%\Desktop" "C:\Users\Public\Desktop") do (
        if not defined wechat_path (
            for %%f in ("%%~d\微信*.lnk" "%%~d\WeChat*.lnk") do (
                for /f "usebackq delims=" %%p in (`powershell -Command "(New-Object -ComObject WScript.Shell).CreateShortcut('%%~ff').TargetPath" 2^>nul`) do (
                    if exist "%%p" (
                        set "wechat_path=%%p"
                        echo 从快捷方式找到安装路径
                        goto :path_found
                    )
                )
            )
        )
    )
)
:path_found

if not defined wechat_path (
    echo 错误：未找到微信安装路径！
    pause
    exit /b 1
)
echo 微信路径：!wechat_path!
echo.

:: 获取多开数量
echo [3/4] 设置多开数量
set "open_count=2"
set /p "open_count=请输入多开数量 (默认2): "

:: 验证输入
echo !open_count!|findstr /r "^[1-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo 提示：输入无效，使用默认值 2
    set "open_count=2"
)

if !open_count! gtr 10 (
    echo 警告：数量过大，限制为 10 个
    set "open_count=10"
)
echo.

:: 启动微信
echo [4/4] 正在启动 !open_count! 个微信...
for /l %%i in (1,1,!open_count!) do (
    echo 启动第 %%i 个微信...
    start "微信%%i" "!wechat_path!"
    timeout /t 1 /nobreak >nul
)

echo.
echo ============================================
echo 成功：!open_count! 个微信已启动！
echo ============================================
echo.
echo 按任意键退出...
pause >nul
exit /b
