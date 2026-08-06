# Show end of file (Linux tail style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [int]$n = 10,
    [switch]$f
)

if ($f) {
    Get-Content $File -Tail $n -Wait
} else {
    Get-Content $File -Tail $n
}