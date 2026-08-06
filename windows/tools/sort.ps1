# Sort text file (Linux sort style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$r,
    [switch]$n,
    [switch]$u
)

$lines = Get-Content $File

if ($n) {
    $lines = $lines | Sort-Object { [double]($_ -replace '\D', '') } -Descending:$r
} else {
    $lines = $lines | Sort-Object -Descending:$r
}

if ($u) { $lines = $lines | Select-Object -Unique }

$lines