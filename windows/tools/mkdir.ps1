<#
.SYNOPSIS
Make directories (Linux mkdir style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
    [switch]$p  # 创建父目录
)

New-Item -ItemType Directory -Path $Path -Force:$p | Out-Null
