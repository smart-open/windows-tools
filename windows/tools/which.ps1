# Find command path (Linux which style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command
)

$env:Path -split ";" | ForEach-Object {
    $path = $_
    @(".exe", ".cmd", ".bat", ".ps1", ".com") | ForEach-Object {
        $fullPath = Join-Path $path "$Command$_"
        if (Test-Path $fullPath) { Write-Host $fullPath }
    }
    $fullPath = Join-Path $path $Command
    if (Test-Path $fullPath -PathType Leaf) { Write-Host $fullPath }
}