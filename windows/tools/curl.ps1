<#
.SYNOPSIS
HTTP client (Linux curl style)
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Url,
    [string]$Method = "GET",
    [string]$OutFile,
    [string]$Headers
)

$params = @{
    Uri = $Url
    Method = $Method
    UseBasicParsing = $true
}

if (-not [string]::IsNullOrEmpty($OutFile)) {
    $params['OutFile'] = $OutFile
}

try {
    $response = Invoke-WebRequest @params
    if ([string]::IsNullOrEmpty($OutFile)) {
        $response.Content
    } else {
        Write-Host "HTTP $Method $Url"
    }
} catch {
    Write-Host "Error: $_"
}
