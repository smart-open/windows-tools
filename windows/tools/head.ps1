# Show beginning of file (Linux head style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [int]$n = 10
)

Get-Content $File -Head $n