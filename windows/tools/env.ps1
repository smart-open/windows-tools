# Print environment variables (Linux env style)
param(
    [Parameter(Position = 0)]
    [string]$Name
)

if ($Name) {
    [Environment]::GetEnvironmentVariable($Name)
} else {
    Get-ChildItem Env: | ForEach-Object { Write-Host "$($_.Name)=$($_.Value)" }
}