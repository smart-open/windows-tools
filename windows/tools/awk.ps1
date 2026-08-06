<#
.SYNOPSIS
Simple awk-like text processor (simplified version)
#>

param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Script,        # awk脚本: '{print $1}'
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$File,          # 输入文件
    [string]$FS = " "       # 字段分隔符
)

# 如果没有文件，尝试从管道读取
if ([string]::IsNullOrEmpty($File)) {
    $inputData = $input
} else {
    $inputData = Get-Content $File
}

if (-not $inputData) {
    Write-Host "Usage: awk '{print `$1}' file.txt"
    Write-Host "   or: cat file.txt | awk '{print `$1, `$2}'"
    Write-Host ""
    Write-Host "Supported operations:"
    Write-Host "  print `$1, `$2, ...  - Print specific fields"
    Write-Host "  print `$0           - Print entire line"
    Write-Host "  print NF            - Print number of fields"
    Write-Host "  print NR            - Print line number"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  awk '{print `$1}' file.txt"
    Write-Host "  awk '{print NR `": `" `$1}' file.txt"
    Write-Host "  awk '{if (`$1 -gt 100) print `$0}' file.txt"
    exit 1
}

$lineNum = 0
foreach ($line in $inputData) {
    $lineNum++
    $fields = $line -split "\s+" | Where-Object { $_ }
    $NF = $fields.Count
    $NR = $lineNum

    # 处理脚本
    $output = $Script

    # 替换 $0 - 整行
    $output = $output -replace '\$0', "`$line"

    # 替换 $1, $2, $3...
    for ($i = 1; $i -le $NF; $i++) {
        $output = $output -replace "\`$$i", "`$(`$fields[$($i-1)])"
    }

    # 替换 NF 和 NR
    $output = $output -replace 'NF', "`$NF"
    $output = $output -replace 'NR', "`$NR"

    # 移除花括号
    $output = $output -replace '^\s*\{', ''
    $output = $output -replace '\}\s*$', ''

    try {
        # 执行脚本
        Invoke-Expression $output
    } catch {
        # 如果执行失败，直接输出
        Write-Output $line
    }
}
