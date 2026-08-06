# Build and execute command lines from standard input (Linux xargs style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command,
    [int]$n = 0,
    [Parameter(ValueFromPipeline = $true)]
    [string]$Input
)

begin {
    $items = @()
}

process {
    $items += $_
}

end {
    if ($n -gt 0) {
        for ($i = 0; $i -lt $items.Length; $i += $n) {
            $batch = $items[$i..([Math]::Min($i + $n - 1, $items.Length - 1))]
            & $Command @batch
        }
    } else {
        & $Command @items
    }
}