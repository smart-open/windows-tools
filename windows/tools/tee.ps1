# Read from standard input and write to standard output and files (Linux tee style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$a,
    [Parameter(ValueFromPipeline = $true)]
    [string]$Input
)

begin {
    $encoding = if ($a) { "Append" } else { "Create" }
}

process {
    $_ | Out-File -FilePath $File -Encoding UTF8 -Append:$a
    $_
}