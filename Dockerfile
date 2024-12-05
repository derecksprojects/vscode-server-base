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
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Install code-server
RUN npm install -g --unsafe-perm code-server@latest

# Create a user and configure the environment
RUN useradd -m -s /bin/zsh ${USERNAME} \
    && echo "${USERNAME}:${PASSWORD}" | chpasswd \
    && usermod -aG sudo ${USERNAME}

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
