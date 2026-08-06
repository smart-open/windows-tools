# Print resolved path (Linux realpath style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

[System.IO.Path]::GetFullPath($Path)