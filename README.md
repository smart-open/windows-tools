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
│       ├── ls.ps1, du.ps1, df.ps1...
│       ├── install.ps1                    # 安装脚本
│       └── README.md                      # tools说明文档
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

在 Windows PowerShell 中使用 Linux 风格的常用命令。

**包含命令（25+个）：**

| 类别 | 命令 |
|------|------|
| 文件操作 | ls, pwd, cp, mv, rm, mkdir, touch |
| 文件查看 | cat, head, tail, more, less, grep, wc |
| 系统信息 | df, du, free, uptime |
| 进程管理 | ps, top, kill |
| 网络工具 | ip, netstat, ss |
| 压缩下载 | zip, unzip, wget, curl |
| 其他 | history |

**安装使用：**
```powershell
cd windows/tools
.\install.ps1
```

**使用示例：**
```powershell
ls -la        # 列出文件
df -h         # 磁盘使用
free -h       # 内存使用
ps            # 进程列表
grep pattern  # 搜索文本
```

详细说明请参考：`windows/tools/README.md`

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

### Linux
- 部分诊断功能需要 root 权限
- 建议在测试环境中先验证脚本

---

## 开源协议

本仓库脚本仅供学习交流使用，请在下载后24小时内删除。
