<#
.SYNOPSIS
Show network connections (Linux netstat style)
#>

param(
    [switch]$t,  # TCP连接
    [switch]$u,  # UDP连接
    [switch]$l,  # 监听端口
    [switch]$n,  # 数字显示
    [switch]$p   # 显示进程
)

# 使用Windows自带netstat
$params = @()
if ($t) { $params += "-t" }
if ($u) { $params += "-u" }
if ($l) { $params += "-a" }
if ($n) { $params += "-n" }
if ($p) { $params += "-b" }

if ($params.Count -eq 0) {
    netstat -ano
} else {
    netstat @params
}
