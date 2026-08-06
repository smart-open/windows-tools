# Extract fields from each line (Linux cut style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [string]$d = "`t",
    [Parameter(Mandatory = $true)]
    [string]$f
)

$fields = $f -split "," | ForEach-Object { [int]$_ - 1 }

Get-Content $File | ForEach-Object {
    $parts = $_ -split [regex]::Escape($d)
    $result = @()
    foreach ($field in $fields) {
        if ($field -lt $parts.Length) {
            $result += $parts[$field]
        }
    }
    $result -join $d
}