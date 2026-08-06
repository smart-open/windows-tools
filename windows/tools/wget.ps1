<#
.SYNOPSIS
Download files (Linux wget style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Url,
    [string]$OutFile
)

if ([string]::IsNullOrEmpty($OutFile)) {
    $OutFile = Split-Path $Url -Leaf
}

Invoke-WebRequest -Uri $Url -OutFile $OutFile
Write-Host "Downloaded: $Url -> $OutFile"
