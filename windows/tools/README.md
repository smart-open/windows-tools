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
| awk | 文本处理(简化) | `awk '{print $1}' file.txt`, `cat file.txt | awk '{print $1}'` |

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
| htop | 交互式进程查看 | `htop`, `htop -Delay 1` |
| kill | 终止进程 | `kill 1234`, `kill -9 1234` (强制) |

### 网络工具

| 命令 | 功能说明 | 用法示例 |
|------|---------|---------|
| ip | 网络接口信息 | `ip`, `ip a` |
| netstat | 网络连接 | `netstat`, `netstat -tlnp` |
| ss | 套接字统计 | `ss`, `ss -t` (TCP) |
| dig | DNS查询(简化) | `dig google.com`, `dig google.com MX`, `dig google.com NS` |

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

---

## 新命令详细说明

### 🔍 dig - DNS查询工具

**功能：** 查询DNS记录（简化版）

**支持的查询类型：**
- A - IPv4地址记录
- MX - 邮件交换记录
- NS - 域名服务器记录
- TXT - 文本记录
- CNAME - 别名记录

**用法示例：**
```powershell
dig google.com              # 查询A记录
dig google.com MX           # 查询邮件服务器
dig google.com NS           # 查询域名服务器
dig google.com TXT          # 查询TXT记录
```

---

### 📝 awk - 文本处理工具

**功能：** 简单的awk风格文本处理

**支持的变量：**
- `$0` - 整行内容
- `$1, $2, $3...` - 第N个字段
- `NF` - 字段数量
- `NR` - 当前行号

**用法示例：**
```powershell
# 打印第一列
awk '{print $1}' file.txt

# 打印行号和整行
awk '{print NR ": " $0}' file.txt

# 管道输入
cat file.txt | awk '{print $1, $2}'
```

---

### 🖥️ htop - 交互式进程查看器

**功能：** 简化版htop，实时显示系统资源和进程

**特点：**
- CPU和内存使用进度条可视化
- 按CPU排序的进程列表
- 自动刷新（默认2秒）
- 按Q键退出

**用法示例：**
```powershell
htop                    # 启动htop（默认2秒刷新）
htop -Delay 1          # 1秒刷新一次
htop -ShowProcess 20   # 显示20个进程
```

**操作：**
- `Q` 键：退出程序
- 不支持滚动和交互排序（简化版）

---

## 技术说明

- 所有命令均使用 PowerShell 脚本实现，无需安装额外软件
- 支持常见的 Linux 风格参数
- 由于 PowerShell 限制，部分功能与原版 Linux 命令可能略有差异

## 实现状态

✅ 已实现（28个命令）：
- **文件操作**: ls, pwd, cp, mv, rm, mkdir, touch
- **文件查看**: cat, head, tail, more, less, grep, wc, **awk**
- **系统信息**: df, du, free, uptime
- **进程管理**: ps, top, kill, **htop**
- **网络工具**: ip, netstat, ss, **dig**
- **压缩下载**: zip, unzip, wget, curl
- **其他**: history

## 注意事项

- 首次使用需要将 tools 目录添加到系统 PATH
- 重启终端后才能使用新命令
- 某些命令需要管理员权限（如 netstat -b）
- htop 的交互式功能较为简化，仅支持刷新和退出
- awk 仅支持基础的字段打印，不支持复杂模式匹配
