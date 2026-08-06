# Count lines, words, characters (Linux wc style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$l,
    [switch]$w,
    [switch]$c
)

$content = Get-Content $File -Raw
$lines = ($content -split "`n").Count
$words = ($content -split "\s+").Count
$chars = $content.Length

if (-not $l -and -not $w -and -not $c) { $l = $w = $c = $true }

$result = @()
if ($l) { $result += $lines }
if ($w) { $result += $words }
if ($c) { $result += $chars }
$result += $File

Write-Host ($result -join " ")