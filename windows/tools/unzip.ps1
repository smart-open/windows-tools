<#
.SYNOPSIS
Extract zip files (Linux unzip style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [string]$Destination = "."
)

Expand-Archive -Path $File -DestinationPath $Destination -Force
Write-Host "Extracted: $File"
