# Show socket statistics (Linux ss style)
param(
    [switch]$t,
    [switch]$u,
    [switch]$l,
    [switch]$n
)

$params = @()
if ($t -or $u) {
    if ($t) { $params += "-p", "tcp" }
    if ($u) { $params += "-p", "udp" }
}
if ($l) { $params += "-a" }

Get-NetTCPConnection @params | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess | Format-Table -AutoSize