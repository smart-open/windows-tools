# Strip filename from path (Linux dirname style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

$dir = Split-Path $Path -Parent
if ($dir -eq "") { $dir = "." }
$dir