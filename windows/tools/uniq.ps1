# Remove consecutive duplicate lines (Linux uniq style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$c,
    [switch]$d,
    [switch]$u
)

$lines = Get-Content $File
$prev = $null
$count = 0

foreach ($line in $lines) {
    if ($line -eq $prev) {
        $count++
    } else {
        if ($prev -ne $null) {
            if ($d -and $count -gt 1) { Write-Host $prev }
            elseif ($u -and $count -eq 1) { Write-Host $prev }
            elseif (-not $d -and -not $u) {
                if ($c) { Write-Host "    $count $prev" }
                else { Write-Host $prev }
            }
        }
        $prev = $line
        $count = 1
    }
}

if ($prev -ne $null) {
    if ($d -and $count -gt 1) { Write-Host $prev }
    elseif ($u -and $count -eq 1) { Write-Host $prev }
    elseif (-not $d -and -not $u) {
        if ($c) { Write-Host "    $count $prev" }
        else { Write-Host $prev }
    }
}