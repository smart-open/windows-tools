# Interactive process viewer (Linux htop style - simplified)
param(
    [int]$Delay = 2,
    [int]$ShowProcess = 15,
    [ValidateSet("CPU", "MEM", "PID")]
    [string]$SortBy = "CPU"
)

Clear-Host

while ($true) {
    try {
        [Console]::SetCursorPosition(0, 0)
    } catch {}

    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $memTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $memUsed = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 2)
    $memPercent = [math]::Round(($memUsed / $memTotal) * 100, 1)
    $cpuUsage = $cpu.LoadPercentage
    if ($null -eq $cpuUsage) { $cpuUsage = 0 }

    $processes = Get-Process | Select-Object Id, ProcessName, CPU, WorkingSet
    switch ($SortBy.ToUpper()) {
        "CPU" { $processes = $processes | Sort-Object CPU -Descending }
        "MEM" { $processes = $processes | Sort-Object WorkingSet -Descending }
        "PID" { $processes = $processes | Sort-Object Id }
    }
    $processes = $processes | Select-Object -First $ShowProcess

    Write-Host "Windows htop - Press Q to quit" -ForegroundColor Cyan
    Write-Host "Time: $(Get-Date -Format 'HH:mm:ss')  Refresh: ${Delay}s  Sort by: $SortBy"
    Write-Host ""

    $cpuBars = [math]::Floor($cpuUsage / 5)
    $cpuBar = ("#" * $cpuBars) + ("-" * (20 - $cpuBars))
    Write-Host "CPU[$cpuBar] $cpuUsage%"  -ForegroundColor Green

    $memBars = [math]::Floor($memPercent / 5)
    $memBar = ("#" * $memBars) + ("-" * (20 - $memBars))
    Write-Host "Mem[$memBar] $memPercent% ($memUsed GB / $memTotal GB)"  -ForegroundColor Green
    Write-Host ""

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
    Write-Host "Controls: Q=Quit | C=CPU sort | M=MEM sort | P=PID sort" -ForegroundColor DarkGray

    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        switch ($key.Key.ToString().ToUpper()) {
            "Q" { break }
            "C" { $SortBy = "CPU" }
            "M" { $SortBy = "MEM" }
            "P" { $SortBy = "PID" }
        }
    }

    Start-Sleep -Seconds $Delay
}

Clear-Host
Write-Host "Exited htop"