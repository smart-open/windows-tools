# Strip directory and suffix from filenames (Linux basename style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
    [Parameter(Position = 1)]
    [string]$Suffix
)

$name = Split-Path $Path -Leaf
if ($Suffix -and $name.EndsWith($Suffix)) {
    $name = $name.Substring(0, $name.Length - $Suffix.Length)
}
$name