# Print route packets take to network host (Linux traceroute style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Hostname,
    [int]$MaxHops = 30
)

Write-Host "Tracing route to $Hostname, max $MaxHops hops"
Write-Host ""

for ($ttl = 1; $ttl -le $MaxHops; $ttl++) {
    $result = Test-Connection -ComputerName $Hostname -Count 1 -TimeToLive $ttl -Quiet -ErrorAction SilentlyContinue
    try {
        $ping = Test-Connection -ComputerName $Hostname -Count 1 -TimeToLive $ttl -ErrorAction Stop
        $time = $ping.ResponseTime
        $addr = $ping.Address
        Write-Host "$ttl`t$time ms`t$addr"
        if ($addr -eq $Hostname -or $addr.ToString() -match [regex]::Escape($Hostname)) {
            break
        }
    } catch {
        Write-Host "$ttl`t* * *`tRequest timed out"
    }
}