# Windows Linux 风格命令工具集

在 Windows PowerShell 中使用 Linux 风格的常用命令。

## 安装

1. 以管理员身份打开 PowerShell
2. 进入 tools 目录
3. 运行安装脚本：

```powershell
.\install.ps1
```

4. 重启终端使 PATH 生效

## 可用命令列表

### 文件和目录操作

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| ls | 列出目录内容 | `ls`, `ls -la`, `ls -h` |
| pwd | 显示当前路径 | `pwd` |
| cd | 切换目录 | `cd C:\Users` (PowerShell自带) |
| cp | 复制文件 | `cp source.txt dest.txt`, `cp -r dir1 dir2` |
| mv | 移动文件 | `mv old.txt new.txt` |
| rm | 删除文件 | `rm file.txt`, `rm -rf dir` |
| mkdir | 创建目录 | `mkdir newdir`, `mkdir -p a/b/c` |
| touch | 创建空文件 | `touch newfile.txt` |

### 文件查看和搜索

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| cat | 查看文件内容 | `cat file.txt`, `cat -n file.txt` (带行号) |
| head | 查看文件开头 | `head file.txt`, `head -n 20 file.txt` |
| tail | 查看文件结尾 | `tail file.txt`, `tail -f log.txt` (实时跟踪) |
| more | 分页查看文件 | `more file.txt` |
| less | 分页查看文件 | `less file.txt` (同more) |
| grep | 搜索文本 | `grep "pattern" file.txt`, `grep -r "pattern" .` |
| wc | 统计字数 | `wc file.txt`, `wc -l file.txt` (行数) |

### 系统信息

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| df | 磁盘使用情况 | `df`, `df -h` (人类可读) |
| du | 目录大小 | `du`, `du -sh`, `du -d 1` |
| free | 内存使用 | `free`, `free -h` |
| uptime | 系统运行时间 | `uptime` |

### 进程管理

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| ps | 列出进程 | `ps`, `ps -a`, `ps -n 10` |
| top | 进程资源排行 | `top`, `top -n 15` |
| kill | 终止进程 | `kill 1234`, `kill -9 1234` (强制) |

### 网络工具

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| ip | 网络接口信息 | `ip`, `ip a` |
| netstat | 网络连接 | `netstat`, `netstat -tlnp` |
| ss | 套接字统计 | `ss`, `ss -t` (TCP) |

### 压缩和下载

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| zip | 创建压缩包 | `zip archive.zip file.txt` |
| unzip | 解压文件 | `unzip archive.zip`, `unzip archive.zip -d dest` |
| wget | 下载文件 | `wget https://example.com/file.txt` |
| curl | HTTP请求 | `curl https://example.com` |

### 其他

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| history | 命令历史 | `history`, `history 10` |

## 技术说明

- 所有命令均使用 PowerShell 脚本实现，无需安装额外软件
- 支持常见的 Linux 风格参数
- 由于 PowerShell 限制，部分功能与原版 Linux 命令可能略有差异

## 实现状态

✅ 可实现（无需外部依赖）：
- ls, pwd, cp, mv, rm, mkdir, touch
- cat, head, tail, more, less, grep, wc
- df, du, free, uptime
- ps, top, kill
- ip, netstat, ss
- zip, unzip, wget, curl
- history

❌ 难以/无法实现（需外部工具）：
- dig (需额外工具)
- htop (交互式界面复杂)
- awk (文本处理复杂)

## 注意事项

- 首次使用需要将 tools 目录添加到系统 PATH
- 重启终端后才能使用新命令
- 某些命令需要管理员权限（如 netstat -b）
