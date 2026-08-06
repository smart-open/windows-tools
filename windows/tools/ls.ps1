# List directory contents (Linux ls style)
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = ".",
    [switch]$l,
    [switch]$a,
    [switch]$h,
    [switch]$r
)

$params = @{
    Path = $Path
    Force = $a
    Recurse = $r
}

if ($l) {
    Get-ChildItem @params | ForEach-Object {
        $size = if ($h) {
            if ($_.Length -ge 1GB) { "{0:N2}GB" -f ($_.Length / 1GB) }
            elseif ($_.Length -ge 1MB) { "{0:N2}MB" -f ($_.Length / 1MB) }
            elseif ($_.Length -ge 1KB) { "{0:N2}KB" -f ($_.Length / 1KB) }
            else { "$($_.Length)B" }
        } else { $_.Length }
        
        $type = if ($_.PSIsContainer) { "d" } else { "-" }
        $lastWrite = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        [PSCustomObject]@{
            Mode = $type + $_.Mode
            LastWriteTime = $lastWrite
            Length = $size
            Name = $_.Name
        }
    } | Format-Table -AutoSize
} else {
    Get-ChildItem @params | Select-Object -ExpandProperty Name
}