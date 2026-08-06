<#
.SYNOPSIS
Create zip archive (Linux zip style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Archive,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Path,
    [switch]$r  # 递归
)

Compress-Archive -Path $Path -DestinationPath $Archive -Force:$r
Write-Host "Created: $Archive"
