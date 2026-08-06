<#
.SYNOPSIS
Remove files or directories (Linux rm style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
    [switch]$r,  # 递归删除
    [switch]$f,  # 强制删除
    [switch]$i   # 交互式删除
)

Remove-Item -Path $Path -Recurse:$r -Force:$f -Confirm:$i
