# Remove files or directories (Linux rm style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
    [switch]$r,
    [switch]$f,
    [switch]$i
)

Remove-Item -Path $Path -Recurse:$r -Force:$f -Confirm:$i