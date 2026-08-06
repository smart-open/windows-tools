# Docker 工具脚本

本目录包含 Docker 相关的安装、部署和管理脚本。

## 脚本列表

| 脚本 | 功能 | 使用场景 |
|------|------|---------|
| **docker_install.sh** | 自动安装最新版 Docker Engine + Compose | 新服务器初始化 |
| **docker_compose_deploy.sh** | 一键部署 26+ 基础设施组件 | 开发/测试环境搭建 |
| **docker_cleaner.sh** | Docker 资源清理工具 | 定期维护 |

## 快速开始

### 1. 安装 Docker

```bash
# 赋予执行权限
chmod +x *.sh

# 快速安装（中国镜像源）
sudo ./docker_install.sh -y --mirror china

# 验证安装
docker --version
docker compose version
```

### 2. 部署基础设施

```bash
# 查看可用组件
./docker_compose_deploy.sh list

# 交互式部署
./docker_compose_deploy.sh deploy

# 指定组件部署
./docker_compose_deploy.sh deploy redis,mysql,postgresql,minio,rustfs

# Redis 哨兵 + MongoDB 副本集
./docker_compose_deploy.sh deploy redis:sentinel,mysql,mongodb:rs

# 启动/停止/状态
./docker_compose_deploy.sh up
./docker_compose_deploy.sh down
./docker_compose_deploy.sh status

# 查看凭据信息
./docker_compose_deploy.sh info
```

### 3. 清理 Docker 资源

```bash
# 清理所有无用资源
./docker_cleaner.sh -a

# 查看磁盘使用
./docker_cleaner.sh -s
```

## 支持的组件 (26个)

| 类别 | 组件 | 版本 |
|------|------|------|
| 数据库 | Redis, MySQL, PostgreSQL, MongoDB | 8.0, 8.4 LTS, 17, 8.0 |
| 搜索 | Elasticsearch, OpenSearch | 8.19, 2.19 |
| 存储 | MinIO, RustFS | latest, latest |
| 消息队列 | RabbitMQ, Kafka, RocketMQ, Pulsar | 4.3, 8.3, 5.5, 4.2 |
| 协调 | ZooKeeper | 3.9 |
| 网关 | OpenResty, Kong | 1.27, 3.9 |
| 监控 | Prometheus, Grafana, Loki, SkyWalking | 3.13, 12.4, 3.7, 10.4 |
| 日志 | Logstash, Kibana | 8.19 |
| 安全 | Keycloak, Sentinel | 26.6, 1.8 |
| 调度 | XXL-Job, PowerJob | 3.4, 5.1 |
| 注册中心 | Nacos | 3.2 |

## 预设方案

| 方案 | 包含组件 |
|------|---------|
| dev-minimal | redis, mysql, minio |
| dev-full | redis, mysql, postgresql, mongodb, minio, nacos, rabbitmq, kafka, zookeeper |
| monitoring | prometheus, grafana, loki |
| elk | elasticsearch, kibana, logstash |
| all-databases | redis, mysql, postgresql, mongodb |
| all-mq | rabbitmq, kafka, rocketmq, zookeeper, pulsar |
| storage | minio, rustfs |

## 数据目录

所有数据卷统一挂载到 `~/docker-stack/data/` 目录下。