<#
.SYNOPSIS
Create empty file or update timestamp (Linux touch style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File
)

if (Test-Path $File) {
    (Get-Item $File).LastWriteTime = Get-Date
} else {
    New-Item -ItemType File -Path $File -Force | Out-Null
}
