# DNS lookup tool (Linux dig style)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Domain,
    [Parameter(Position = 1)]
    [string]$Type = "A"
)

Write-Host "; <<>> Windows dig <<>> $Domain $Type"
Write-Host ";; SERVER: System DNS"
Write-Host ""

try {
    switch ($Type.ToUpper()) {
        "A" {
            $result = [System.Net.Dns]::GetHostEntry($Domain)
            Write-Host ";; ANSWER SECTION:"
            foreach ($ip in $result.AddressList) {
                if ($ip.AddressFamily -eq "InterNetwork") {
                    Write-Host "$Domain.    IN    A    $($ip.IPAddressToString)"
                }
            }
        }
        "AAAA" {
            $result = [System.Net.Dns]::GetHostEntry($Domain)
            Write-Host ";; ANSWER SECTION:"
            foreach ($ip in $result.AddressList) {
                if ($ip.AddressFamily -eq "InterNetworkV6") {
                    Write-Host "$Domain.    IN    AAAA    $($ip.IPAddressToString)"
                }
            }
        }
        "MX" {
            $result = Resolve-DnsName -Name $Domain -Type MX -ErrorAction Stop
            Write-Host ";; ANSWER SECTION:"
            foreach ($record in $result) {
                Write-Host "$Domain.    IN    MX    $($record.Preference) $($record.NameExchange)"
            }
        }
        "NS" {
            $result = Resolve-DnsName -Name $Domain -Type NS -ErrorAction Stop
            Write-Host ";; ANSWER SECTION:"
            foreach ($record in $result) {
                Write-Host "$Domain.    IN    NS    $($record.NameHost)"
            }
        }
        "TXT" {
            $result = Resolve-DnsName -Name $Domain -Type TXT -ErrorAction Stop
            Write-Host ";; ANSWER SECTION:"
            foreach ($record in $result) {
                Write-Host "$Domain.    IN    TXT    `"$($record.Strings)`""
            }
        }
        "CNAME" {
            $result = Resolve-DnsName -Name $Domain -Type CNAME -ErrorAction Stop
            Write-Host ";; ANSWER SECTION:"
            foreach ($record in $result) {
                Write-Host "$Domain.    IN    CNAME    $($record.NameHost)"
            }
        }
        default {
            Write-Host "Unsupported type: $Type"
            Write-Host "Supported: A, AAAA, MX, NS, TXT, CNAME"
        }
    }
} catch {
    Write-Host ";; ERROR: $_"
}

Write-Host ""
Write-Host ";; Query completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"