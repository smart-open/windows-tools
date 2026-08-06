<#
.SYNOPSIS
Show end of file (Linux tail style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [int]$n = 10,  # 显示行数
    [switch]$f     # 实时跟踪
)

if ($f) {
    Get-Content $File -Tail $n -Wait
} else {
    Get-Content $File -Tail $n
}
