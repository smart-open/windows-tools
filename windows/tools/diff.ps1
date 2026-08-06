# Compare files line by line (Linux diff style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File1,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$File2,
    [switch]$u,
    [switch]$c
)

$lines1 = Get-Content $File1
$lines2 = Get-Content $File2

$diff = Compare-Object -ReferenceObject $lines1 -DifferenceObject $lines2 -IncludeEqual

if ($c) {
    $diff | ForEach-Object {
        $prefix = switch ($_.SideIndicator) {
            "<=" { "--- " }
            "=>" { "+++ " }
            "==" { "    " }
        }
        Write-Host "$prefix$($_.InputObject)"
    }
} else {
    $diff | ForEach-Object {
        $prefix = switch ($_.SideIndicator) {
            "<=" { "< " }
            "=>" { "> " }
            "==" { "  " }
        }
        Write-Host "$prefix$($_.InputObject)"
    }
}