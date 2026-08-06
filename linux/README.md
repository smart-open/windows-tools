# Linux 实用脚本集合

本目录包含17个运维实用脚本，涵盖系统监控、备份、安全审计、部署管理、Docker基础设施等多个领域。

---

## 脚本列表

### 📊 系统监控类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **system_monitor.sh** | 实时系统监控 | CPU/内存/磁盘监控、阈值告警、进程排名 |
| **process_watchdog.sh** | 进程守护监控 | 异常自动重启、邮件告警、多进程监控 |
| **io_monitor.sh** | 磁盘I/O监控 | 读写速度统计、Top I/O进程、阈值告警 |

### 💾 备份恢复类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **backup_manager.sh** | 文件备份管理器 | 全量/增量备份、自动清理、压缩存储 |
| **db_backup.sh** | 数据库备份 | MySQL/PostgreSQL支持、自动轮换恢复 |

### 🔐 安全审计类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **security_audit.sh** | 系统安全扫描 | 端口检查、SUID扫描、弱权限审计、内核加固 |
| **ssh_key_manage.sh** | SSH密钥管理 | 批量分发、远程部署、连接测试 |
| **sudo_audit.sh** | sudo权限审计 | 密码检查、命令限制、日志审计 |

### 🌐 网络工具类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **port_scanner.sh** | 端口扫描器 | TCP/UDP扫描、服务发现、Ping Sweep |
| **traceroute.sh** | 路由追踪 | 节点检测、延迟统计 |

### 🐳 Docker相关

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **docker_cleaner.sh** | Docker清理工具 | 容器/镜像/卷/网络清理、定期执行 |

### 🚀 部署发布类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **service_deploy.sh** | 服务部署工具 | 一键部署、版本回滚、健康检查 |

### ⚡ 性能调优类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **system_tuner.sh** | 系统参数调优 | 网络优化、内存调优、文件系统配置 |

### 📝 日志分析类

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **log_analyzer.sh** | 日志分析器 | Auth/Nginx/系统日志分析、HTML报告生成 |
| **error_summary.sh** | 错误汇总告警 | 多日志聚合、统计报表、邮件告警 |

### 🐳 Docker基础设施类 (位于 `docker/` 子目录)

| 脚本 | 功能 | 主要特性 |
|------|------|---------|
| **docker/docker_install.sh** | Docker自动安装 | CentOS/Ubuntu自动检测、最新版安装、中国镜像源支持 |
| **docker/docker_compose_deploy.sh** | 基础设施一键部署 | 26+组件模板(含RustFS)、单机/集群模式、7种预设方案、统一数据卷管理 |
| **docker/docker_cleaner.sh** | Docker资源清理 | 容器/镜像/卷/网络清理、磁盘使用统计 |
| **docker/DEPLOYMENT_GUIDE.md** | 详细部署操作手册 | 完整安装/部署/使用/运维/故障排查文档 |

---

## 快速开始

### 通用要求
- 所有脚本需在Linux环境运行
- 部分脚本需要root权限
- 建议使用root或sudo执行

### 设置执行权限
```bash
chmod +x *.sh
```

### 脚本帮助信息
所有脚本均支持 `-h` 参数查看详细帮助：
```bash
./system_monitor.sh -h
./backup_manager.sh -h
./security_audit.sh -h
```

---

## 各脚本使用说明

### system_monitor.sh
系统资源实时监控工具

```bash
# 基本监控（默认5秒间隔）
./system_monitor.sh

# 2秒间隔，告警阈值80%
./system_monitor.sh -i 2 -t 80
```

---

### process_watchdog.sh
关键进程守护，异常自动重启

```bash
# 监控nginx和mysql，30秒检查一次
./process_watchdog.sh -c nginx -c mysql -i 30

# 查看监控状态
./process_watchdog.sh -s
```

---

### backup_manager.sh
灵活的备份管理工具

```bash
# 全量备份
./backup_manager.sh -p /data -d /backup -t full

# 增量备份
./backup_manager.sh -p /data -d /backup -t incr

# 恢复备份
./backup_manager.sh -r /backup/xxx.tar.gz -p /restore
```

---

### db_backup.sh
数据库自动备份

```bash
# MySQL备份
./db_backup.sh -t mysql -u root -p password -d mydb

# PostgreSQL备份
./db_backup.sh -t pgsql -u postgres -d mydb
```

---

### security_audit.sh
全面系统安全审计

```bash
# 完整审计
./security_audit.sh

# 指定输出报告文件
./security_audit.sh -o /var/log/audit_report.log
```

---

### ssh_key_manage.sh
SSH密钥批量管理

```bash
# 生成密钥
./ssh_key_manage.sh -a generate

# 批量添加密钥到主机
./ssh_key_manage.sh -a add -k ~/.ssh/id_rsa.pub -h hosts.txt -u root

# 批量删除密钥
./ssh_key_manage.sh -a remove -h hosts.txt
```

---

### port_scanner.sh
网络端口扫描

```bash
# 扫描常用端口
./port_scanner.sh -t 192.168.1.100

# 指定端口范围
./port_scanner.sh -t 192.168.1.100 -p 1-1000

# 扫描子网
./port_scanner.sh -s 192.168.1.0/24
```

---

### service_deploy.sh
自动化服务部署

```bash
# 部署新版本
./service_deploy.sh -n myapp -v 1.2.0 -a deploy -u http://.../app.tar.gz

# 回滚到上一版本
./service_deploy.sh -n myapp -a rollback
```

---

### docker_cleaner.sh
Docker资源清理

```bash
# 清理所有无用资源
./docker_cleaner.sh -a

# 只清理悬空镜像
./docker_cleaner.sh -i

# 显示磁盘使用情况
./docker_cleaner.sh -s
```

---

### system_tuner.sh
系统性能调优

```bash
# 检查当前配置
./system_tuner.sh -a check

# 应用服务器优化配置
./system_tuner.sh -p server -a apply

# 应用数据库优化配置
./system_tuner.sh -p database -a apply

# 恢复备份
./system_tuner.sh -a restore
```

---

### log_analyzer.sh
多类型日志分析

```bash
# 分析认证日志
./log_analyzer.sh -l auth

# 分析nginx日志
./log_analyzer.sh -l nginx

# 分析所有日志
./log_analyzer.sh -l all -o report.html
```

---

### error_summary.sh
错误汇总告警

```bash
# 过去24小时汇总
./error_summary.sh -t 24h

# 过去1小时汇总，超过10个错误发邮件
./error_summary.sh -t 1h -e admin@example.com -a 10
```

---

### docker/docker_install.sh
自动安装最新版Docker Engine和Docker Compose（支持CentOS/Ubuntu）

```bash
cd docker/

# 快速安装（默认官方源）
sudo ./docker_install.sh -y

# 使用中国镜像源安装
sudo ./docker_install.sh -y --mirror china

# 交互式安装
sudo ./docker_install.sh
```

功能特性：
- 自动检测CentOS/RHEL/Ubuntu/Debian
- 自动查询最新Docker版本
- 支持阿里云中国镜像源
- 自动配置daemon.json（日志轮转、overlay2）
- 自动添加用户到docker组

---

### docker/docker_compose_deploy.sh
通过Docker Compose一键部署26+基础设施组件（含RustFS）

```bash
cd docker/

# 查看所有可用组件
./docker_compose_deploy.sh list

# 交互式部署（显示菜单和预设方案）
./docker_compose_deploy.sh deploy

# 指定组件部署
./docker_compose_deploy.sh deploy redis,mysql,postgresql,minio,rustfs

# Redis哨兵模式 + MongoDB副本集
./docker_compose_deploy.sh deploy redis:sentinel,mysql,mongodb:rs

# 启动/停止/查看状态
./docker_compose_deploy.sh up
./docker_compose_deploy.sh down
./docker_compose_deploy.sh status

# 查看日志
./docker_compose_deploy.sh logs redis

# 查看部署信息和凭据
./docker_compose_deploy.sh info

# 清理所有容器和数据
./docker_compose_deploy.sh clean
```

**预设方案（交互模式输入字母即可）：**
- `a. dev-minimal`: redis, mysql, minio
- `b. dev-full`: redis, mysql, postgresql, mongodb, minio, nacos, rabbitmq, kafka, zookeeper
- `c. monitoring`: prometheus, grafana, loki
- `d. elk`: elasticsearch, kibana, logstash
- `e. all-databases`: redis, mysql, postgresql, mongodb
- `f. all-mq`: rabbitmq, kafka, rocketmq, zookeeper, pulsar
- `g. storage`: minio, rustfs

**支持的组件（26个）：**

| 类别 | 组件 | 版本 |
|------|------|------|
| 数据库 | Redis, MySQL, PostgreSQL, MongoDB | 8.0, 8.4 LTS, 17, 8.0 |
| 搜索 | Elasticsearch, OpenSearch | 8.19, 2.19 |
| 存储 | MinIO, RustFS | RELEASE.2025-10-15, 1.0.0-alpha.69 |
| 消息队列 | RabbitMQ, Kafka, RocketMQ, Pulsar | 4.3, 8.3, 5.5, 4.2 |
| 协调 | ZooKeeper | 3.9 |
| 网关 | OpenResty, Kong | 1.27, 3.9 |
| 监控 | Prometheus, Grafana, Loki, SkyWalking | 3.13, 12.4, 3.7, 10.4 |
| 日志 | Logstash, Kibana | 8.19 |
| 安全 | Keycloak, Sentinel | 26.6, 1.8 |
| 调度 | XXL-Job, PowerJob | 3.4, 5.1 |
| 注册中心 | Nacos | 3.2 |

**Redis部署模式：** standalone（单机）、sentinel（哨兵1主2从1哨兵）、cluster（6节点集群）
**MongoDB部署模式：** standalone（单机）、rs（1主2从副本集）
**数据卷统一挂载：** `~/docker-stack/data/` 目录下

> 完整部署操作手册请参考: [docker/DEPLOYMENT_GUIDE.md](docker/DEPLOYMENT_GUIDE.md)

---

## 定时任务配置建议

使用crontab定期执行关键脚本：
```bash
# 每日凌晨2点执行完整备份
0 2 * * * /opt/scripts/backup_manager.sh -p /data -d /backup -t full

# 每小时执行错误汇总，超过50个告警
0 * * * * /opt/scripts/error_summary.sh -t 1h -e admin@example.com -a 50

# 每周日执行安全审计
0 3 * * 0 /opt/scripts/security_audit.sh -o /var/log/audit/$(date +\%Y\%m\%d).log

# 每周清理一次Docker
0 4 * * 0 /opt/scripts/docker_cleaner.sh -a
```

---

## 注意事项

1. **权限要求**：大部分脚本需要root权限执行，使用sudo或root用户
2. **依赖工具**：部分脚本依赖如mailx、iostat等系统工具
3. **日志文件**：默认日志输出到 `/var/log/` 目录下
4. **配置备份**：执行系统调优脚本前会自动备份配置
5. **测试环境**：建议在测试环境验证脚本后再在生产环境使用

---

## 版本信息

- Scripts Version: 1.0
- Last Updated: 2024
- Author: System Admin Team

---

## 原有的system_diagnostic脚本

### system_diagnostic.sh
系统综合诊断脚本，详见：[system_diagnostic_readme.md](system_diagnostic_readme.md)
```bash
# 执行完整系统诊断
./system_diagnostic.sh
```

| 脚本 | 主要功能 |
|------|---------|
| **system_diagnostic.sh** | 完整系统诊断 |
| | CPU/内存/磁盘/网络/进程/日志等10大类分析 |
| | 彩色输出、HTML报告生成 |
| | 自动健康评分和建议 |