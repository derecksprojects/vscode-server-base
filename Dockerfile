FROM ubuntu:22.04

# Environment variables for container configuration
ARG USERNAME=developer
ARG PASSWORD=password
ARG PORT=8443

# Update and install essential tools
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    sudo \
    net-tools \
    nano \
    zsh \
    openssl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (required for code-server npm installation)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Ensure the installation environment is clean and ready
RUN npm cache clean --force && \
    rm -rf /usr/lib/node_modules/code-server

# Install code-server globally using npm with proper permissions
RUN npm install -g --unsafe-perm code-server

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create a non-root user and configure environment
RUN useradd -ms /bin/bash -G sudo $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    mkdir -p /home/$USERNAME && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME

# Expose the port for code-server
EXPOSE $PORT

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
