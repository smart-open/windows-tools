# Simple awk-like text processor
param(
    [Parameter(Position = 0)]
    [string]$Script,
    [Parameter(Position = 1)]
    [string]$File,
    [string]$FS = " "
)

if ([string]::IsNullOrEmpty($File)) {
    $inputData = $input
} else {
    $inputData = Get-Content $File
}

if (-not $inputData) {
    Write-Host "Usage: awk '{print `$1}' file.txt"
    Write-Host "   or: cat file.txt | awk '{print `$1, `$2}'"
    Write-Host ""
    Write-Host "Supported: print `$1..`$N, `$0, NF, NR"
    exit 1
}

$lineNum = 0
foreach ($line in $inputData) {
    $lineNum++
    $fields = $line -split "\s+" | Where-Object { $_ }
    $NF = $fields.Count
    $NR = $lineNum

    $output = $Script
    $output = $output -replace '\$0', "`$line"
    for ($i = 1; $i -le $NF; $i++) {
        $output = $output -replace "\`$$i", "`$(`$fields[$($i-1)])"
    }
    $output = $output -replace 'NF', "`$NF"
    $output = $output -replace 'NR', "`$NR"
    $output = $output -replace '^\s*\{', ''
    $output = $output -replace '\}\s*$', ''

    try {
        Invoke-Expression $output
    } catch {
        Write-Output $line
    }
}