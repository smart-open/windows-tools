# Show network connections (Linux netstat style)
param(
    [switch]$t,
    [switch]$u,
    [switch]$l,
    [switch]$n,
    [switch]$p
)

$params = @()
if ($t) { $params += "-t" }
if ($u) { $params += "-u" }
if ($l) { $params += "-a" }
if ($n) { $params += "-n" }
if ($p) { $params += "-b" }

if ($params.Count -eq 0) {
    netstat -ano
} else {
    netstat @params
}