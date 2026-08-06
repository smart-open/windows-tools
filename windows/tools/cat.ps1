<#
.SYNOPSIS
Display file contents (Linux cat style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$n  # 显示行号
)

if ($n) {
    $i = 1
    Get-Content $File | ForEach-Object {
        Write-Host ("{0,6}  {1}" -f $i++, $_)
    }
} else {
    Get-Content $File
}
