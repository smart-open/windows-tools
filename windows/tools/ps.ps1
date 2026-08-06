<#
.SYNOPSIS
List processes (Linux ps style)
#>

param(
    [switch]$a,  # 显示所有进程
    [switch]$u,  # 显示详细用户信息
    [int]$n = 20 # 显示前N个进程(按CPU)
)

if ($a) {
    Get-Process | Select-Object Id, ProcessName, CPU, WorkingSet, StartTime | Format-Table -AutoSize
} else {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First $n | 
        Select-Object Id, ProcessName, @{Name='CPU(s)';Expression={[math]::Round($_.CPU,1)}},
            @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet/1MB,1)}}, StartTime | Format-Table -AutoSize
}
