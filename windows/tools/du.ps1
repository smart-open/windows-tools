<#
.SYNOPSIS
Disk usage (Linux du style)
#>

param(
    [string]$Path = ".",
    [switch]$h,  # 人类可读
    [switch]$s,  # 汇总
    [int]$d = 2  # 深度
)

function Format-Size($bytes) {
    if ($null -eq $bytes) { return "0B" }
    if ($bytes -ge 1GB) { "{0:N2}GB" -f ($bytes / 1GB) }
    elseif ($bytes -ge 1MB) { "{0:N2}MB" -f ($bytes / 1MB) }
    elseif ($bytes -ge 1KB) { "{0:N2}KB" -f ($bytes / 1KB) }
    else { "$bytes B" }
}

if ($s) {
    $total = (Get-ChildItem -Path $Path -Recurse -File | Measure-Object Length -Sum).Sum
    if ($h) {
        Write-Host "$(Format-Size $total) $Path"
    } else {
        Write-Host "$total $Path"
    }
} else {
    Get-ChildItem -Path $Path -Directory -Depth $d | ForEach-Object {
        $size = (Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
        if ($h) {
            Write-Host "$(Format-Size $size) $($_.FullName)"
        } else {
            Write-Host "$size $($_.FullName)"
        }
    }
}
