FROM ubuntu:22.04

# Define ENVs without defaults - these will be required at runtime
ENV USERNAME=""
ENV PORT=""
ENV PASSWORD=""
ENV HOME=""
ENV NVM_DIR="/usr/local/nvm"
ENV NODE_VERSION="lts/*"

WORKDIR /workspace

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    sudo \
    net-tools \
    nano \
    zsh \
    openssl && \
    rm -rf /var/lib/apt/lists/*

# Install nvm and Node.js LTS version
RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    ln -s $NVM_DIR/versions/node/$(nvm version default)/bin/node /usr/local/bin/node && \
    ln -s $NVM_DIR/versions/node/$(nvm version default)/bin/npm /usr/local/bin/npm && \
    ln -s $NVM_DIR/versions/node/$(nvm version default)/bin/npx /usr/local/bin/npx

# Export PATH to ensure nvm and Node.js tools are available
ENV PATH=$NVM_DIR/versions/node/$(nvm alias default | grep -o 'v[0-9\.]*')/bin:$PATH

# Create user and setup directories for VS Code Server
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install code-server as root using npm
RUN npm install -g code-server@latest

# Create SSL certificates directory
RUN mkdir -p /etc/code-server

# Expose the necessary ports
EXPOSE 8000-9000

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
