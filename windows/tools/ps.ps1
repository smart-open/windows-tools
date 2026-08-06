# List processes (Linux ps style)
param(
    [switch]$a,
    [switch]$u,
    [int]$n = 20
)

if ($a) {
    Get-Process | Select-Object Id, ProcessName, CPU, WorkingSet, StartTime | Format-Table -AutoSize
} else {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First $n |
        Select-Object Id, ProcessName, @{Name='CPU(s)';Expression={[math]::Round($_.CPU,1)}},
            @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet/1MB,1)}}, StartTime | Format-Table -AutoSize
}