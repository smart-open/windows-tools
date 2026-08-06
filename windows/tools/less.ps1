<#
.SYNOPSIS
Page through text (Linux less style, using more)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File
)

# Windows下用more代替
Get-Content $File | Out-Host -Paging
