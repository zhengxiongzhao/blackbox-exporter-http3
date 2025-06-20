# blackbox-exporter-http3

## 概述

`blackbox-exporter-http3` 是一个基于 [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter) 的项目，用于通过 HTTP/3 协议探测目标服务。该项目使用自定义的 `curl` 镜像，并通过 GitHub Actions 自动构建和发布 Docker 镜像。

## 功能

- **HTTP/3 探测**: 使用 `curl` 的 HTTP/3 支持来探测目标服务是否支持并正确响应 HTTP/3。
- **多平台支持**: 支持 `linux/amd64` 和 `linux/arm64` 平台。

## 使用方法

### 1. 使用 Docker Compose

您可以使用 Docker Compose 来运行 `blackbox-exporter-http3`。以下是一个示例 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  blackbox:
    image: zhengxiongzhao/blackbox-exporter-http3:latest
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./etc/prometheus/blackbox.yml:/config/blackbox.yml
    ports:
      - '9115:9115'
    depends_on:
      - prometheus

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - '9090:9090'
```

### 2. 配置 `blackbox.yml`

在 `blackbox.yml` 文件中配置 `http3_script_prober` 模块。以下是一个示例配置：

```yaml
modules:
  http3_script_prober:
    prober: script
    timeout: 10s
    script:
      command: "/bin/sh"
      args:
        - -c
        - 'curl --http3-only -s -o /dev/null -L -w "%{http_code}" "${TARGET}"'
      expect:
        stdout:
          regex:
            - "2.."
            - "3.."
        exit_code: 0
```

### 3. 运行 Docker Compose

使用以下命令启动 Docker Compose：

```bash
docker-compose up -d
```

### 4. 探测目标服务

您可以使用 `blackbox-exporter` 的 HTTP/3 探测功能来探测目标服务。例如，使用以下 URL 进行探测：

```
http://localhost:9115/probe?module=http3_script_prober&target=https://example.com
```

### 示例

假设您想探测 `https://example.com` 是否支持 HTTP/3，可以使用以下命令：

```bash
curl "http://localhost:9115/probe?module=http3_script_prober&target=https://example.com"
```

这将返回探测结果，指示目标服务是否支持 HTTP/3。

## 许可证

本项目采用 [MIT 许可证](LICENSE)。