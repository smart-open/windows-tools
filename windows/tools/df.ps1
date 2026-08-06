<#
.SYNOPSIS
Show disk usage (Linux df style)
#>

param(
    [switch]$h  # 人类可读格式
)

$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 -or $_.Free -gt 0 }

$results = $drives | ForEach-Object {
    $total = $_.Used + $_.Free
    if ($h) {
        $used = if ($_.Used -ge 1GB) { "{0:N2}GB" -f ($_.Used / 1GB) }
                elseif ($_.Used -ge 1MB) { "{0:N2}MB" -f ($_.Used / 1MB) }
                else { "{0:N2}KB" -f ($_.Used / 1KB) }
        $free = if ($_.Free -ge 1GB) { "{0:N2}GB" -f ($_.Free / 1GB) }
                elseif ($_.Free -ge 1MB) { "{0:N2}MB" -f ($_.Free / 1MB) }
                else { "{0:N2}KB" -f ($_.Free / 1KB) }
        $totalStr = if ($total -ge 1GB) { "{0:N2}GB" -f ($total / 1GB) }
                    elseif ($total -ge 1MB) { "{0:N2}MB" -f ($total / 1MB) }
                    else { "{0:N2}KB" -f ($total / 1KB) }
    } else {
        $used = $_.Used
        $free = $_.Free
        $totalStr = $total
    }
    
    $usePercent = if ($total -gt 0) { [math]::Round(($_.Used / $total) * 100, 1) } else { 0 }
    
    [PSCustomObject]@{
        Filesystem = $_.Name
        Size = $totalStr
        Used = $used
        Available = $free
        UsePercent = "$usePercent%"
        Mounted = $_.Root
    }
}

$results | Format-Table -AutoSize
