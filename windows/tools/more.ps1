<#
.SYNOPSIS
Page through text (Linux more style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File
)

Get-Content $File | Out-Host -Paging
