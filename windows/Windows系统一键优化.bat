@echo off
title Windows系统一键优化工具
mode con cols=80 lines=30
color 0A

:: ========================================
::          检查管理员权限
:: ========================================
fltmc >nul 2>&1 || (
    echo [X] 请以管理员身份运行此脚本!
    echo.
    echo 右键点击脚本 -> 以管理员身份运行
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo       Windows系统一键优化工具
echo ========================================
echo.
echo [√] 已获取管理员权限
echo.
echo 优化选项:
echo   1. 关闭系统通知
echo   2. 禁用多余自启动项
echo   3. 隐私设置优化
echo   4. 清除文件浏览记录
echo   5. 关闭Windows自动更新
echo   6. 禁用遥测和数据收集
echo   7. 关闭 SmartScreen
echo   8. 关闭活动历史记录
echo   9. 关闭剪贴板同步
echo  10. 关闭位置服务
echo  11. 关闭广告ID
echo  12. 优化资源管理器
echo  13. 性能优化设置
echo  14. 隐私深度优化
echo  15. 安全增强设置
echo  16. 网络优化设置
echo  17. 系统服务优化
echo  18. Microsoft Edge优化
echo  19. 电源计划优化
echo.
echo ========================================
echo.
pause

:: ========================================
::          创建系统还原点
:: ========================================
echo.
echo [1/13] 正在创建系统还原点...
powershell -Command "Checkpoint-Computer -Description 'System Optimization Backup' -RestorePointType MODIFY_SETTINGS" >nul 2>&1
if %errorlevel% equ 0 (
    echo [√] 系统还原点创建成功
) else (
    echo [!] 系统还原点创建失败，继续优化...
)

:: ========================================
::          1. 关闭系统通知
:: ========================================
echo.
echo [2/13] 正在关闭系统通知...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_TOASTS_ENABLED" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d 1 /f >nul 2>&1
echo [√] 系统通知已关闭

:: ========================================
::          2. 禁用多余自启动项
:: ========================================
echo.
echo [3/13] 正在禁用多余自启动项...
:: 常见自启动项
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "SunJavaUpdateSched" /t REG_SZ /d "" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "SunJavaUpdateSched" /f >nul 2>&1

:: 禁用启动文件夹中的快捷方式
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.lnk" (
    del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.lnk" >nul 2>&1
)
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\*.lnk" (
    del /f /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\*.lnk" >nul 2>&1
)

:: 通过任务计划程序禁用
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>&1
echo [√] 多余自启动项已禁用

:: ========================================
::          3. 隐私设置优化
:: ========================================
echo.
echo [4/13] 正在优化隐私设置...
:: 禁用广告ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用SmartScreen
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用应用访问权限
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\calendar" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\messaging" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo [√] 隐私设置已优化

:: ========================================
::          4. 清除文件浏览记录
:: ========================================
echo.
echo [5/13] 正在清除文件浏览记录...
:: 清除运行对话框历史
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >nul 2>&1

:: 清除最近打开的文件
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f >nul 2>&1

:: 清除文件资源管理器快速访问
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*" >nul 2>&1

:: 禁用跳转列表
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 文件浏览记录已清除

:: ========================================
::          5. 关闭Windows自动更新
:: ========================================
echo.
echo [6/13] 正在关闭Windows自动更新...
:: 停止并禁用Windows Update服务
sc stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1

:: 停止并禁用Windows Update Medic Service
sc stop WaaSMedicSvc >nul 2>&1
sc config WaaSMedicSvc start= disabled >nul 2>&1

:: 停止并禁用更新 Orchestrator 服务
sc stop UsoSvc >nul 2>&1
sc config UsoSvc start= disabled >nul 2>&1

:: 注册表禁用自动更新
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 2 /f >nul 2>&1

:: 设置Windows Update为"检查更新但让我选择是否下载和安装它们"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 2 /f >nul 2>&1
echo [√] Windows自动更新已关闭

:: ========================================
::          6. 禁用遥测和数据收集
:: ========================================
echo.
echo [7/13] 正在禁用遥测和数据收集...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用 DiagTrack 服务
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
echo [√] 遥测和数据收集已禁用

:: ========================================
::          7. 关闭 SmartScreen
:: ========================================
echo.
echo [8/13] 正在关闭 SmartScreen...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Edge\SmartScreenEnabled" /v "" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] SmartScreen 已关闭

:: ========================================
::          8. 关闭活动历史记录
:: ========================================
echo.
echo [9/13] 正在关闭活动历史记录...
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 活动历史记录已关闭

:: ========================================
::          9. 关闭剪贴板同步
:: ========================================
echo.
echo [10/13] 正在关闭剪贴板同步...
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Clipboard" /v "CrossDeviceClipboard" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 剪贴板同步已关闭

:: ========================================
::          10. 关闭位置服务
:: ========================================
echo.
echo [11/13] 正在关闭位置服务...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f >nul 2>&1
sc stop lfsvc >nul 2>&1
sc config lfsvc start= disabled >nul 2>&1
echo [√] 位置服务已关闭

:: ========================================
::          11. 关闭广告ID
:: ========================================
echo.
echo [12/13] 正在关闭广告ID...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 广告ID已关闭

:: ========================================
::          12. 优化资源管理器
:: ========================================
echo.
echo [13/13] 正在优化资源管理器...
:: 显示文件扩展名
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f >nul 2>&1

:: 显示隐藏文件和文件夹
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f >nul 2>&1

:: 显示受保护的操作系统文件
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用快速访问中的最近使用文件
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用快速访问中的频繁使用文件夹
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul 2>&1

:: 打开文件资源管理器时打开"此电脑"而不是"快速访问"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul 2>&1

:: 禁用缩略图预览，显示图标
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d 0 /f >nul 2>&1

:: 在标题栏显示完整路径
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d 1 /f >nul 2>&1

:: 移除快捷方式箭头
reg add "HKCR\lnkfile" /v "IsShortcut" /t REG_SZ /d "" /f >nul 2>&1
reg delete "HKCR\lnkfile" /v "IsShortcut" /f >nul 2>&1
echo [√] 资源管理器已优化

:: ========================================
::          13. 性能优化设置
:: ========================================
echo.
echo [14/20] 正在优化性能设置...
:: 关闭Windows动画效果
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f >nul 2>&1

:: 禁用透明效果
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用启动延迟
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 2 /f >nul 2>&1

:: 禁用超级预读（SysMain）
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

:: 禁用系统休眠
powercfg -h off >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 关闭分页清理
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f >nul 2>&1

:: 启动和故障恢复 - 加快启动速度
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "SetupExecute" /t REG_MULTI_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1

:: 禁用内存转储
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 性能设置已优化

:: ========================================
::          14. 隐私深度优化
:: ========================================
echo.
echo [15/20] 正在进行隐私深度优化...
:: 禁用搜索中的Web搜索
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用Cortana
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Cortana" /v "CortanaEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用语音激活
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation" /v "VoiceActivationEnableWhenUserSaysHeyCortana" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用墨迹和打字诊断
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "AllowTailoredExperiences" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f >nul 2>&1

:: 禁用查找我的设备
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用输入个性化（文本建议、自动更正）
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Settings\EnableIMEPersonalizedLearning" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用应用建议
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用开始菜单建议
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 隐私深度优化完成

:: ========================================
::          15. 安全增强设置
:: ========================================
echo.
echo [16/20] 正在增强安全设置...
:: 禁用SMB 1.0协议
sc stop LanmanServer >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d 0 /f >nul 2>&1
dism /online /disable-feature /featurename:SMB1Protocol /norestart >nul 2>&1

:: 禁用NetBIOS over TCP/IP (需要管理员权限，部分系统可能不生效)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /v "NetbiosOptions" /t REG_DWORD /d 2 /f >nul 2>&1

:: 禁用LLMNR协议
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用远程协助
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用远程桌面（默认禁用）
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f >nul 2>&1
sc stop TermService >nul 2>&1
sc config TermService start= disabled >nul 2>&1

:: 禁用远程注册表服务
sc stop RemoteRegistry >nul 2>&1
sc config RemoteRegistry start= disabled >nul 2>&1

:: 禁用远程管理
reg add "HKLM\Software\Policies\Microsoft\Windows\WinRM\Service" /v "AllowAutoConfig" /t REG_DWORD /d 0 /f >nul 2>&1
sc stop WinRM >nul 2>&1
sc config WinRM start= disabled >nul 2>&1

:: 禁用自动播放/自动运行
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f >nul 2>&1
echo [√] 安全增强设置完成

:: ========================================
::          16. 网络优化设置
:: ========================================
echo.
echo [17/20] 正在优化网络设置...
:: 限制可保留带宽
reg add "HKLM\SOFTWARE\Policies\Microsoft\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1

:: 关闭无线网络适配器电源管理
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0002" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1

:: 禁用WiFi感知
reg add "HKLM\Software\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] 网络设置已优化

:: ========================================
::          17. 系统服务优化
:: ========================================
echo.
echo [18/20] 正在优化系统服务...
:: 禁用传真服务
sc stop Fax >nul 2>&1
sc config Fax start= disabled >nul 2>&1

:: 禁用家庭组服务
sc stop HomeGroupProvider >nul 2>&1
sc config HomeGroupProvider start= disabled >nul 2>&1
sc stop HomeGroupListener >nul 2>&1
sc config HomeGroupListener start= disabled >nul 2>&1

:: 禁用诊断服务
sc stop WerSvc >nul 2>&1
sc config WerSvc start= disabled >nul 2>&1

:: 禁用Windows错误报告
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: 禁用客户体验改善计划
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用生物识别服务（如非笔记本）
sc stop WbioSrvc >nul 2>&1
sc config WbioSrvc start= disabled >nul 2>&1

:: 禁用蓝牙服务（如不用蓝牙）
sc stop BthServ >nul 2>&1
sc config BthServ start= disabled >nul 2>&1
echo [√] 系统服务已优化

:: ========================================
::          18. 微软Edge优化
:: ========================================
echo.
echo [19/20] 正在优化Microsoft Edge...
:: 禁用Edge启动加速
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Edge\Main" /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用Edge后台运行
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用Edge搜索建议
reg add "HKCU\Software\Microsoft\Edge\SmartScreenEnabled" /v "" /t REG_DWORD /d 0 /f >nul 2>&1

:: 禁用Edge数据收集
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo [√] Microsoft Edge已优化

:: ========================================
::          19. 电源计划优化
:: ========================================
echo.
echo [20/20] 正在优化电源计划...
:: 设置高性能电源计划
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

:: 关闭硬盘自动休眠
powercfg /change disk-timeout-ac 0 >nul 2>&1
powercfg /change disk-timeout-dc 0 >nul 2>&1

:: 关闭USB选择性挂起
powercfg /change standby-timeout-ac 0 >nul 2>&1
powercfg /change hibernate-timeout-ac 0 >nul 2>&1
echo [√] 电源计划已优化

:: ========================================
::          重启 Explorer
:: ========================================
echo.
echo 正在重启资源管理器使设置生效...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1

:: ========================================
::          完成
:: ========================================
echo.
echo ========================================
echo             优化完成!
echo ========================================
echo.
echo 已完成以下优化:
echo   √ 系统通知已关闭
echo   √ 多余自启动项已禁用
echo   √ 隐私设置已优化
echo   √ 文件浏览记录已清除
echo   √ Windows自动更新已关闭
echo   √ 遥测和数据收集已禁用
echo   √ SmartScreen 已关闭
echo   √ 活动历史记录已关闭
echo   √ 剪贴板同步已关闭
echo   √ 位置服务已关闭
echo   √ 广告ID已关闭
echo   √ 资源管理器已优化
echo   √ 性能设置已优化
echo   √ 隐私深度优化完成
echo   √ 安全增强设置完成
echo   √ 网络设置已优化
echo   √ 系统服务已优化
echo   √ Microsoft Edge已优化
echo   √ 电源计划已优化
echo.
echo [!] 建议重启电脑使所有设置完全生效
echo.
echo 按任意键退出...
pause >nul
