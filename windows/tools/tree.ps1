# Display directory tree (Linux tree style)
param(
    [Parameter(Position = 0)]
    [string]$Path = ".",
    [int]$Level = 0,
    [switch]$a,
    [switch]$f
)

function Show-Tree {
    param($dir, $prefix = "", $level = 0)
    
    if ($Level -gt 0 -and $level -ge $Level) { return }
    
    $items = Get-ChildItem -Path $dir -Force:$a
    $count = $items.Count
    $i = 0
    
    foreach ($item in $items) {
        $i++
        $isLast = $i -eq $count
        $connector = if ($isLast) { "`\-- " } else { "|-- " }
        $itemPath = if ($f) { $item.FullName } else { $item.Name }
        Write-Host "$prefix$connector$itemPath"
        
        if ($item.PSIsContainer) {
            $newPrefix = if ($isLast) { "$prefix    " } else { "$prefix|   " }
            Show-Tree $item.FullName $newPrefix ($level + 1)
        }
    }
}

Write-Host $Path
Show-Tree $Path