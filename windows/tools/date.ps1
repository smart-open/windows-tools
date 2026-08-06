# Print or set system date and time (Linux date style)
param(
    [string]$Format = "yyyy-MM-dd HH:mm:ss"
)

Get-Date -Format $Format