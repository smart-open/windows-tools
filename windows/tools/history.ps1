<#
.SYNOPSIS
Show command history (Linux history style)
#>

param(
    [int]$n  # 显示最近N条
)

$history = Get-History
if ($n -gt 0) {
    $history = $history | Select-Object -Last $n
}

$history | ForEach-Object {
    Write-Host ("{0,5}  {1}" -f $_.Id, $_.CommandLine)
}
