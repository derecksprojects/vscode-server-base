# vscode-server-base

Visual Studio Code Server Docker Image based on Ubuntu 22.04 with basic CLI tools installed such as curl, wget, git. This image is intended to be used as a base for building a development environment with Visual Studio Code Server.

## Usage

I recommend using `docker compose` to run the container. Here is an example `docker-compose.yml` file:

```yaml
services:
  vscode-server:
    image: vscode-server
    container_name: vscode-server
    build:
      context: .
      dockerfile: Dockerfile
      args:
        USERNAME: ${USERNAME}
        PORT: ${PORT}
        PASSWORD: ${PASSWORD}
    environment:
      PASSWORD: ${PASSWORD}
      PORT: ${PORT}
      HOME: /home/${USERNAME}
    ports:
      - "${PORT}:${PORT}"
    volumes:
      - ${HOST_VOLUME}:/home/${USERNAME}:rw
    restart: unless-stopped
    tty: true

```

Use a `.env` file to set the environment variables:

```bash
USERNAME=dereck
HOST_VOLUME=/media/nvme0/vscode-server
PASSWORD=your_secure_password
PORT=8443
```

Notice this image allows you to mount a volume which would allow you to persist your projects.