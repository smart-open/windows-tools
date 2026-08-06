<#
.SYNOPSIS
Install Linux-style tools to Windows PATH
#>

$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$toolsPath*") {
    $newPath = "$currentPath;$toolsPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added to PATH: $toolsPath"
    Write-Host "Please restart your terminal to use the commands."
} else {
    Write-Host "Already in PATH: $toolsPath"
}

Write-Host ""
Write-Host "Available commands:"
Write-Host "  ls, du, df, free, top, uptime"
Write-Host "  ps, kill, history"
Write-Host "  cat, grep, head, tail, wc, more, less"
Write-Host "  touch, pwd, cp, rm, mkdir, mv"
Write-Host "  ip, netstat, ss"
Write-Host "  unzip, zip, wget, curl"
Write-Host ""
Write-Host "Usage: ps -n 20, ls -la, df -h, etc."
