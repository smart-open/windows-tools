# Display file contents (Linux cat style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$n
)

if ($n) {
    $i = 1
    Get-Content $File | ForEach-Object {
        Write-Host ("{0,6}  {1}" -f $i++, $_)
    }
} else {
    Get-Content $File
}