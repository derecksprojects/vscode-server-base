FROM ubuntu:22.04

# Define ENVs without defaults - these will be required at runtime
ENV USERNAME=""
ENV PORT=""
ENV PASSWORD=""
ENV HOME=""

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
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create user and setup directories for VS Code Server
# Use an entrypoint script to handle user creation at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install code-server as root
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create SSL certificates directory
RUN mkdir -p /etc/code-server

EXPOSE 8000-9000

ENTRYPOINT ["/entrypoint.sh"]