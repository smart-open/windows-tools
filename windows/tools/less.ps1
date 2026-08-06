# Page through text (Linux less style, using more)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File
)

Get-Content $File | Out-Host -Paging