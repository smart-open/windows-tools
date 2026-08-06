# Display calendar (Linux cal style)
param(
    [int]$Month,
    [int]$Year,
    [switch]$y
)

if (-not $Month) { $Month = (Get-Date).Month }
if (-not $Year) { $Year = (Get-Date).Year }

$firstDay = Get-Date -Year $Year -Month $Month -Day 1
$daysInMonth = [DateTime]::DaysInMonth($Year, $Month)
$startDayOfWeek = [int]$firstDay.DayOfWeek

$monthName = $firstDay.ToString("MMMM yyyy")
Write-Host ("`n{0,20}" -f $monthName)
Write-Host "Su Mo Tu We Th Fr Sa"

$day = 1
for ($i = 0; $i -lt 6; $i++) {
    $line = ""
    for ($j = 0; $j -lt 7; $j++) {
        if (($i -eq 0 -and $j -lt $startDayOfWeek) -or $day -gt $daysInMonth) {
            $line += "   "
        } else {
            $line += ("{0,2} " -f $day)
            $day++
        }
    }
    Write-Host $line
    if ($day -gt $daysInMonth) { break }
}
Write-Host ""