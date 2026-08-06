<#
.SYNOPSIS
Open file explorer in current or specified directory (Linux open style)
#>
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = "."
)

$resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
if ($resolvedPath) {
    explorer.exe $resolvedPath.Path
} else {
    Write-Error "Path not found: $Path"
    exit 1
}
