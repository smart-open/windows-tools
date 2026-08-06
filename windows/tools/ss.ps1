<#
.SYNOPSIS
Show socket statistics (Linux ss style)
#>

param(
    [switch]$t,  # TCP
    [switch]$u,  # UDP
    [switch]$l,  # 监听
    [switch]$n   # 数字显示
)

$params = @()
if ($t -or $u) {
    if ($t) { $params += "-p", "tcp" }
    if ($u) { $params += "-p", "udp" }
}
if ($l) { $params += "-a" }

Get-NetTCPConnection @params | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess | Format-Table -AutoSize
