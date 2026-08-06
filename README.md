# 实用脚本集合

一个跨平台的实用脚本集合，包含 Windows 和 Linux 常用工具。

## 目录结构

```
scripts/
├── README.md                    # 主说明文档
├── .gitignore                   # Git忽略文件
├── LICENSE                      # 开源协议
│
├── windows/                     # Windows 脚本目录
│   ├── Window Beyond Compare重置试用.bat  # BC试用期重置
│   ├── Window微信多开.bat                  # 微信多开工具
│   └── tools/                             # Linux风格命令工具集
│       ├── ls.ps1, du.ps1, df.ps1...     # 28个Linux风格命令
│       ├── install.ps1                    # 安装脚本
│       └── README.md                      # tools详细说明
│
└── linux/                       # Linux 脚本目录
    ├── system_diagnostic.sh               # 系统诊断脚本
    └── system_diagnostic_readme.md        # 诊断脚本说明
```

---

## Windows 脚本

### 🔧 windows/Window Beyond Compare重置试用.bat

**功能：** 重置 Beyond Compare 4.x/5.x 的试用期

**使用说明：**
1. 右键以管理员身份运行
2. 脚本自动清除注册表中的试用标记
3. 自动搜索并启动 Beyond Compare 程序
4. 重置后试用期重新计算为30天

**特点：**
- 支持 BC 4.x 和 5.x 版本
- 自动搜索多个安装路径（C/D盘、Program Files、Program Files (x86)）
- 支持从桌面快捷方式查找

---

### 💬 windows/Window微信多开.bat

**功能：** 快速启动多个微信实例

**使用说明：**
1. 直接运行脚本（无需管理员权限）
2. 输入需要多开的数量（默认2个，最大10个）
3. 脚本自动启动所有微信实例
4. 逐个登录微信账号即可

**特点：**
- 支持微信运行中直接多开，无需先关闭
- 自动搜索多个安装路径
- 启动间隔1秒，避免启动过快问题
- 最多支持同时启动10个微信实例

**建议：** 快速启动多个微信app，随后一个一个登录即可

---

### 🛠️ windows/tools/ - Linux风格命令工具集

在 Windows PowerShell 中使用 Linux 风格的常用命令（共28个命令）。

**安装使用：**
```powershell
cd windows/tools
.\install.ps1
```

#### 快速参考

| 类别 | 命令列表 |
|------|---------|
| **文件操作** | ls, pwd, cp, mv, rm, mkdir, touch |
| **文件查看** | cat, head, tail, more, less, grep, wc, **awk** |
| **系统信息** | df, du, free, uptime |
| **进程管理** | ps, top, kill, **htop** |
| **网络工具** | ip, netstat, ss, **dig** |
| **压缩下载** | zip, unzip, wget, curl |
| **其他** | history |

#### 新增命令详细说明

##### 🔍 dig - DNS查询工具

**功能：** 查询DNS记录（支持IPv6）

**支持的查询类型：**
- A - IPv4地址记录
- **AAAA - IPv6地址记录（新增）**
- MX - 邮件交换记录
- NS - 域名服务器记录
- TXT - 文本记录
- CNAME - 别名记录

**用法示例：**
```powershell
dig google.com              # 查询IPv4地址
dig google.com AAAA         # 查询IPv6地址
dig google.com MX           # 查询邮件服务器
dig google.com NS           # 查询域名服务器
```

---

##### 📝 awk - 文本处理工具

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

##### 🖥️ htop - 交互式进程查看器

**功能：** 简化版htop，实时显示系统资源和进程

**特点：**
- CPU和内存使用进度条可视化 (█ ░)
- 按CPU/内存/PID排序（运行时可切换）
- 自动刷新（默认2秒）
- 按Q键退出

**用法示例：**
```powershell
htop                           # 默认按CPU排序启动
htop -SortBy MEM              # 按内存排序启动
htop -Delay 1 -SortBy PID     # 1秒刷新，按PID排序
```

**运行时按键操作：**
- `Q` 键：退出程序
- `C` 键：按CPU使用率排序
- `M` 键：按内存使用率排序
- `P` 键：按PID排序

---

## Linux 脚本

### 🖥️ linux/system_diagnostic.sh

**功能：** Linux 系统综合诊断工具

**使用说明：**
```bash
chmod +x system_diagnostic.sh
./system_diagnostic.sh
```

**诊断内容：**
- 系统基本信息
- CPU 使用情况
- 内存使用情况
- 磁盘空间分析
- 网络连接状态
- 进程运行情况
- 系统日志分析

详细说明请参考：`linux/system_diagnostic_readme.md`

---

## 使用方法

### Windows 脚本
1. 进入 `windows/` 目录
2. 下载对应 `.bat` 文件到本地
3. 根据需要右键以管理员身份运行或直接运行
4. 按照提示操作即可

### Linux 脚本
1. 进入 `linux/` 目录
2. 下载对应 `.sh` 文件
3. 添加执行权限：`chmod +x script.sh`
4. 运行脚本：`./script.sh`

---

## 注意事项

### Windows
- 所有批处理脚本均使用 UTF-8 编码，如遇中文乱码请确认编码设置
- Beyond Compare 重置工具需要管理员权限修改注册表
- tools/ 目录下的 PowerShell 脚本需要先运行 install.ps1 添加到 PATH
- htop 的交互式功能较为简化，仅支持刷新和排序切换
- awk 仅支持基础的字段打印，不支持复杂模式匹配

### Linux
- 部分诊断功能需要 root 权限
- 建议在测试环境中先验证脚本

---

## 开源协议

本仓库脚本仅供学习交流使用，请在下载后24小时内删除。
