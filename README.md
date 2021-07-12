# manjaro-package-mirror
Docker container which mirrors manjaro packages and serves them via nginx

This image is based on the alpine image and uses rsync to synchronize the packages and nginx to deliver them

## Supported Architectures
The image is built for the **amd64** and **arm64** platform and is available in the **DockerHub** and the **Github Container Registry** respectively.

## Parameters
A container can be started with various parameters to make changes to the default configuration, expose ports, and persist data. For example, `-p 8080:80` would expose port 80 inside the container for access from outside via port 8080. The following parameters are available for this image:

| Parameter                                                            | Function                                                    |
| -------------------------------------------------------------------- | ----------------------------------------------------------- |
| `-p 8080:80`                                                         | Binds container port 80 to host port 8080                   |
| `-v /path/to/storage:/srv/http/manjaro`                              | Persists the package repository data under /path/to/storage |
| `-e SOURCE_MIRROR=rsync://mirrorservice.org/repo.manjaro.org/repos/` | Allows to use another mirror for synchronization            |
| `-e SLEEP=6h`                                                        | Adjusts the pause time between synchronizations             |

## Usage
The container can be started either with `docker run` or `docker-compose`

**Please make sure to choose a suitable directory for persistence before running the container and replace the placeholder "/path/to/storage" chosen here with it.**

### docker-compose (recommended)
````yaml
---
version: "3.4"
services:
  manjaro-mirror:
    container_name: manjaro-mirror
    image: ghcr.io/twiese99/manjaro-package-mirror
    volumes:
      - /path/to/storage:/srv/http/manjaro
    ports:
      - 8080:80
    restart: unless-stopped
````

### docker run
````bash
docker run -d \
  --name=manjaro-mirror \
  -p 8080:80 \
  -v /path/to/storage:/srv/http/manjaro \
  --restart unless-stopped \
  ghcr.io/twiese99/manjaro-package-mirror
````




