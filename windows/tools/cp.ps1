# Copy files or directories (Linux cp style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Source,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Destination,
    [switch]$r,
    [switch]$f
)

Copy-Item -Path $Source -Destination $Destination -Recurse:$r -Force:$f