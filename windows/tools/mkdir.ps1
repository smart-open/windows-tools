# Make directories (Linux mkdir style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
    [switch]$p
)

New-Item -ItemType Directory -Path $Path -Force:$p | Out-Null