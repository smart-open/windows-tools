<#
.SYNOPSIS
Kill processes (Linux kill style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Id,
    [int]$Signal = 9  # 信号(默认9=强制终止)
)

try {
    $proc = Get-Process -Id $Id -ErrorAction Stop
    if ($Signal -eq 9) {
        $proc.Kill()
        Write-Host "Process $Id killed (SIGKILL)"
    } else {
        Stop-Process -Id $Id -Force
        Write-Host "Process $Id terminated"
    }
} catch {
    Write-Host "Error: Process $Id not found"
}
