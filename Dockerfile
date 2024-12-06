# Base image
FROM ubuntu:22.04

# Set environment variables with defaults
ENV USERNAME=developer \
    PASSWORD=password \
    PORT=8443

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    vim \
    nano \
    zsh \
    net-tools \
    python3 \
    python3-pip \
    sudo \
    gnupg \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Install code-server with explicit version that's compatible with Node 20
RUN npm install -g --unsafe-perm code-server@4.20.0

# Create a user and configure the environment
RUN useradd -m -s /bin/zsh ${USERNAME} \
    && echo "${USERNAME}:${PASSWORD}" | chpasswd \
    && usermod -aG sudo ${USERNAME}

# Create SSL directory
RUN mkdir -p /home/${USERNAME}/.ssl && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssl

# Expose port for VS Code Server
EXPOSE ${PORT}

# Set up the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to the created user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Set entrypoint
ENTRYPOINT ["entrypoint.sh"]