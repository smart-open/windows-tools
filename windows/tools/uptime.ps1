<#
.SYNOPSIS
Show system uptime
#>

$os = Get-CimInstance Win32_OperatingSystem
$uptime = (Get-Date) - $os.LastBootUpTime

Write-Host "System up for: $($uptime.Days) days, $($uptime.Hours):$($uptime.Minutes.ToString('00')):$($uptime.Seconds.ToString('00'))"
Write-Host "Last boot: $($os.LastBootUpTime.ToString('yyyy-MM-dd HH:mm:ss'))"
