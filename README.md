# Manjaro Package Mirror 🚀

[![Build Status](https://github.com/tobiaswx/manjaro-package-mirror/actions/workflows/docker-multiarch-build.yml/badge.svg)](https://github.com/tobiaswx/manjaro-package-mirror/actions/workflows/docker-multiarch-build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Docker Pulls](https://img.shields.io/docker/pulls/tobiaswx/manjaro-package-mirror)

A Docker container that creates and maintains a local Manjaro Linux package mirror. It uses rsync for efficient synchronization and nginx for serving packages, with built-in monitoring and health checks.

## 🌟 Features

- **Efficient Syncing**: Uses rsync with configurable bandwidth limits
- **Multi-Architecture Support**: Works on both AMD64 and ARM64 platforms
- **Monitoring**: Built-in Prometheus metrics
- **Health Checks**: Automated container health monitoring
- **Performance**: Nginx-based package serving with auto-indexing
- **Security**: Regular vulnerability scanning and updates
- **Logging**: Structured logging with rotation

## 📋 Prerequisites

- Docker Engine 20.10.0 or newer
- At least 100GB of free disk space (for a full mirror)
- Stable network connection

## 🚀 Quick Start

### Using Docker Compose (Recommended)

```yaml
version: "3.8"

services:
  manjaro-mirror:
    container_name: manjaro-mirror
    image: ghcr.io/tobiaswx/manjaro-package-mirror:latest
    volumes:
      - /path/to/storage:/srv/http/manjaro
    ports:
      - "8080:80"
      - "9100:9100"  # Prometheus metrics
    environment:
      - SOURCE_MIRROR=rsync://mirrorservice.org/repo.manjaro.org/repos/
      - RSYNC_BWLIMIT=1000  # KB/s (0 for unlimited)
      - SLEEP=6h
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 5m
      timeout: 3s
      retries: 3
    restart: unless-stopped
```

### Using Docker CLI

```bash
docker run -d \
  --name=manjaro-mirror \
  -p 8080:80 \
  -p 9100:9100 \
  -v /path/to/storage:/srv/http/manjaro \
  -e RSYNC_BWLIMIT=1000 \
  -e SLEEP=6h \
  --restart unless-stopped \
  ghcr.io/tobiaswx/manjaro-package-mirror:latest
```

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `SOURCE_MIRROR` | Rsync mirror URL | `rsync://mirrorservice.org/repo.manjaro.org/repos/` | No |
| `SLEEP` | Time between sync attempts | `6h` | No |
| `RSYNC_BWLIMIT` | Bandwidth limit in KB/s (0 for unlimited) | `0` | No |
| `RSYNC_OPTS` | Additional rsync options | - | No |
| `LOG_LEVEL` | Logging level (debug, info, warn, error) | `info` | No |

### Volumes

| Path | Description | Required |
|------|-------------|----------|
| `/srv/http/manjaro` | Mirror storage location | Yes |
| `/var/log/manjaro-mirror` | Log files location | No |

### Ports

| Port | Description | Required |
|------|-------------|----------|
| 80 | HTTP server (nginx) | Yes |
| 9100 | Prometheus metrics | No |

## 📊 Monitoring

### Health Checks

The container includes built-in health checks accessible at `/health`. Configure your monitoring system to track this endpoint for service health.

### Prometheus Metrics

Access metrics at `:9100/metrics`. Available metrics include:
- Mirror sync status
- Disk usage
- Sync duration
- Error counts

## 🔒 Security

- Regular vulnerability scanning via Trivy
- Automated dependency updates via Dependabot
- Minimal base image (Alpine Linux)
- Regular security patches

## 📝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Commit Convention

This project follows [Conventional Commits](https://www.conventionalcommits.org/):
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `chore`: Routine tasks, maintenance
- `refactor`: Code refactoring
- `test`: Testing changes

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- Create a [GitHub Issue](https://github.com/tobiaswx/manjaro-package-mirror/issues) for bug reports, feature requests, or questions
- Add a ⭐️ star on GitHub to support the project!

## 📊 Project Status

Actively maintained. See the [CHANGELOG](CHANGELOG.md) for recent updates.

## 🙏 Acknowledgments

- [Manjaro Linux](https://manjaro.org/) for the package repository
- [Official Manjaro mirrors](https://wiki.manjaro.org/index.php/Manjaro_Mirrors) for providing reliable source mirrors