# Use a base Ubuntu image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install base dependencies
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
    gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Node.js 18.x repository
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Ensure npm cache is clean and retry on failure
RUN npm cache clean --force && \
    npm config set registry https://registry.npmjs.org/ && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 10000 && \
    npm config set fetch-retry-maxtimeout 30000

# Install code-server globally
RUN npm install -g --unsafe-perm code-server

# Create a user and set permissions
ARG USERNAME=developer
ARG PASSWORD=password
RUN useradd -m -s /bin/zsh ${USERNAME} && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd && \
    usermod -aG sudo ${USERNAME}

# Expose the default VS Code Server port
EXPOSE 8443

# Set the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory and user
WORKDIR /home/${USERNAME}
USER ${USERNAME}

# Default command
ENTRYPOINT ["entrypoint.sh"]
