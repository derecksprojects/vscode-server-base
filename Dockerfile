FROM ubuntu:22.04

# Environment variables
ARG USERNAME=developer
ARG PASSWORD=password
ARG PORT=8443

# Install essential tools
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

# Install Node.js and npm for arm/v7 compatibility with code-server
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | bash || \
    npm install -g code-server

# Create a non-root user
RUN useradd -ms /bin/bash -G sudo $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    mkdir -p /home/$USERNAME && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME

# Expose the port for code-server
EXPOSE $PORT

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
