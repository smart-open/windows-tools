# Show network interfaces (Linux ip style)
param(
    [switch]$a
)

$adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' } | Group-Object InterfaceIndex

foreach ($adapter in $adapters) {
    $interface = Get-NetAdapter -InterfaceIndex $adapter.Name -ErrorAction SilentlyContinue
    if ($interface) {
        Write-Host "$($interface.Name):"
        Write-Host "  Link/ether $($interface.MacAddress)"
        foreach ($ip in $adapter.Group) {
            Write-Host "  inet $($ip.IPAddress)/$($ip.PrefixLength)"
        }
        Write-Host ""
    }
}