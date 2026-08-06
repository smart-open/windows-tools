# Search text in files (Linux grep style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Pattern,
    [Parameter(Position = 1)]
    [string]$Path = ".",
    [switch]$i,
    [switch]$r,
    [switch]$n,
    [switch]$v
)

Get-ChildItem -Path $Path -Recurse:$r -File | ForEach-Object {
    $content = Get-Content $_.FullName
    $lineNum = 1
    foreach ($line in $content) {
        $match = if ($v) { $line -notmatch $Pattern } else { $line -match $Pattern }
        if ($match) {
            if ($n) {
                Write-Host "$($_.Name):$lineNum : $line"
            } else {
                Write-Host "$($_.Name): $line"
            }
        }
        $lineNum++
    }
}