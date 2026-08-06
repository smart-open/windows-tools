<#
.SYNOPSIS
Search text in files (Linux grep style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Pattern,
    [Parameter(Position = 1)]
    [string]$Path = ".",
    [switch]$i,  # 忽略大小写
    [switch]$r,  # 递归搜索
    [switch]$n,  # 显示行号
    [switch]$v   # 反向匹配
)

$options = @{}
if ($i) { $options['CaseSensitive'] = $false } else { $options['CaseSensitive'] = $true }

Get-ChildItem -Path $Path -Recurse:$r -File | ForEach-Object {
    $content = Get-Content $_.FullName
    $lineNum = 1
    foreach ($line in $content) {
        $match = if ($v) { $line -notmatch $Pattern } else { $line -match $Pattern }
        if ($match) {
            if ($n) {
                Write-Host "$($_.Name):$lineNum : $line"
            } else {
                Write-Host "$($_.Name): $line"
            }
        }
        $lineNum++
    }
}
