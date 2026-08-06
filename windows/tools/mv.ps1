<#
.SYNOPSIS
Move files (Linux mv style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Source,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Destination,
    [switch]$f  # 强制覆盖
)

Move-Item -Path $Source -Destination $Destination -Force:$f
