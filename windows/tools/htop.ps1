<#
.SYNOPSIS
Interactive process viewer (Linux htop style - simplified)
#>

param(
    [int]$Delay = 2,          # 刷新间隔（秒）
    [int]$ShowProcess = 15,   # 显示进程数
    [ValidateSet("CPU", "MEM", "PID")]
    [string]$SortBy = "CPU"   # 排序方式: CPU, MEM, PID
)

# 清屏
Clear-Host

# 主循环
while ($true) {
    # 获取光标位置
    try {
        $cursorTop = [Console]::CursorTop
        [Console]::SetCursorPosition(0, 0)
    } catch {
        $cursorTop = 0
    }

    # 获取系统信息
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $memTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $memUsed = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 2)
    $memPercent = [math]::Round(($memUsed / $memTotal) * 100, 1)

    # 获取CPU使用
    $cpuUsage = $cpu.LoadPercentage
    if ($null -eq $cpuUsage) { $cpuUsage = 0 }

    # 获取进程信息并排序
    $processes = Get-Process | Select-Object Id, ProcessName, CPU, WorkingSet
    switch ($SortBy.ToUpper()) {
        "CPU" { $processes = $processes | Sort-Object CPU -Descending }
        "MEM" { $processes = $processes | Sort-Object WorkingSet -Descending }
        "PID" { $processes = $processes | Sort-Object Id }
    }
    $processes = $processes | Select-Object -First $ShowProcess

    # 输出标题
    Write-Host "Windows htop (simplified) - Press Q to quit" -ForegroundColor Cyan
    Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  Refresh: ${Delay}s  Sort by: $SortBy"
    Write-Host ""

    # CPU进度条
    $cpuBars = [math]::Floor($cpuUsage / 5)
    $cpuBar = ("█" * $cpuBars) + ("░" * (20 - $cpuBars))
    Write-Host "CPU[$cpuBar] $cpuUsage%"  -ForegroundColor Green

    # 内存进度条
    $memBars = [math]::Floor($memPercent / 5)
    $memBar = ("█" * $memBars) + ("░" * (20 - $memBars))
    Write-Host "Mem[$memBar] $memPercent% ($memUsed GB / $memTotal GB)"  -ForegroundColor Green
    Write-Host ""

    # 进程列表
    Write-Host "  PID   CPU%   MEM(MB)  PROCESS NAME"
    Write-Host "----------------------------------------"

    foreach ($proc in $processes) {
        $pidVal = $proc.Id
        $cpuVal = if ($proc.CPU) { [math]::Round($proc.CPU, 1) } else { 0 }
        $memVal = [math]::Round($proc.WorkingSet / 1MB, 1)
        $name = $proc.ProcessName

        Write-Host ("{0,6} {1,6} {2,9}  {3}" -f $pidVal, $cpuVal, $memVal, $name)
    }

    Write-Host ""
    Write-Host "Controls: Q=Quit | Sort: C=CPU, M=MEM, P=PID" -ForegroundColor DarkGray

    # 检查按键
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        switch ($key.Key.ToString().ToUpper()) {
            "Q" { break }
            "C" { $SortBy = "CPU" }
            "M" { $SortBy = "MEM" }
            "P" { $SortBy = "PID" }
        }
    }

    # 等待
    Start-Sleep -Seconds $Delay
}

Clear-Host
Write-Host "Exited htop"
