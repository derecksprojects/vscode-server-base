# vscode-server-base

A flexible Docker image based on Ubuntu 22.04 that runs VS Code Server, providing a browser-based development environment. This image includes essential development tools and can be used either directly or as a base for custom development environments.

## Features

- Based on Ubuntu 22.04 LTS
- Runs VS Code Server with secure HTTPS (self-signed certificates)
- Configurable at runtime via environment variables
- Pre-installed development tools:
  - Git
  - curl
  - wget
  - build-essential
  - vim
  - nano
  - zsh
  - net-tools
  - sudo access for the created user

## Quick Start

### Using Docker Run

```bash
docker run -d \
  -e USERNAME=myuser \
  -e PORT=8443 \
  -e PASSWORD=mysecurepassword \
  -p 8443:8443 \
  -v /host/path:/home/myuser \
  dereckmezquita/vscode-server-base:latest
```

### Using Docker Compose

1. Create a `docker-compose.yml` file:

```yaml
services:
  vscode-server:
    image: dereckmezquita/vscode-server-base:latest
    container_name: vscode-server
    environment:
      USERNAME: ${USERNAME}
      PORT: ${PORT}
      PASSWORD: ${PASSWORD}
    ports:
      - "${PORT}:${PORT}"
    volumes:
      - ${HOST_VOLUME}:/home/${USERNAME}:rw
    restart: unless-stopped
```

2. Create a `.env` file:

```bash
USERNAME=myuser
PORT=8443
PASSWORD=mysecurepassword
HOST_VOLUME=/path/to/your/workspace
```

3. Start the container:

```bash
docker compose up -d
```

## Required Environment Variables

| Variable  | Description                                    | Example         |
|-----------|------------------------------------------------|-----------------|
| USERNAME  | User to be created in the container            | myuser          |
| PORT      | Port for VS Code Server to listen on           | 8443            |
| PASSWORD  | Password for accessing VS Code Server          | mysecurepassword|

## Using as a Base Image

You can use this image as a base for your custom development environment:

```dockerfile
FROM dereckmezquita/vscode-server-base:latest

# Add your custom installations
RUN apt-get update && apt-get install -y \
    python3 \
    nodejs \
    npm

# Add any additional configuration
COPY my-settings.json /default-settings.json

# Environment variables can still be set when running containers
# based on this derived image
```

## Volume Mounting

To persist your workspace and VS Code settings, mount a volume to the user's home directory:

```bash
-v /host/path:/home/myuser
```

This will persist:
- Your workspace files
- VS Code settings
- VS Code extensions
- Command history

## Security Notes

1. The image generates self-signed SSL certificates for HTTPS
2. Password authentication is required
3. The created user has sudo privileges (required for some VS Code extensions)
4. Sensitive information should be passed via environment variables, not built into derived images

## Contributing

Feel free to open issues or submit pull requests at [GitHub Repository URL].

## License

MIT License

## Acknowledgments

Based on the official VS Code Server implementation and the Ubuntu Docker image.