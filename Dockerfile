FROM ubuntu:22.04

ARG USERNAME
ARG PORT
ARG PASSWORD

ENV USERNAME=${USERNAME}
ENV PORT=${PORT}
ENV PASSWORD=${PASSWORD}
ENV HOME=/home/${USERNAME}

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
RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
        useradd -m -s /bin/bash ${USERNAME} && \
        echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}; \
    fi && \
    mkdir -p /home/${USERNAME}/.local/share/code-server/extensions && \
    mkdir -p /home/${USERNAME}/.local/share/code-server/User && \
    mkdir -p /home/${USERNAME}/.local/share/code-server/Machine && \
    mkdir -p /home/${USERNAME}/.local/share/code-server/logs && \
    mkdir -p /home/${USERNAME}/.local/share/code-server/User/globalStorage && \
    mkdir -p /home/${USERNAME}/.local/share/code-server/User/History && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Create SSL certificates
RUN mkdir -p /etc/code-server && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/code-server/self-signed.key \
    -out /etc/code-server/self-signed.crt \
    -subj "/CN=localhost"

# Install code-server as root
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Switch to unprivileged user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Configure code-server
RUN mkdir -p ~/.config/code-server && \
    echo "bind-addr: 0.0.0.0:${PORT}" > ~/.config/code-server/config.yaml && \
    echo "auth: password" >> ~/.config/code-server/config.yaml && \
    echo "password: ${PASSWORD}" >> ~/.config/code-server/config.yaml && \
    echo "cert: /etc/code-server/self-signed.crt" >> ~/.config/code-server/config.yaml && \
    echo "cert-key: /etc/code-server/self-signed.key" >> ~/.config/code-server/config.yaml

ENTRYPOINT code-server \
    --bind-addr "0.0.0.0:${PORT}" \
    --user-data-dir "/home/${USERNAME}/.local/share/code-server" \
    --config "/home/${USERNAME}/.config/code-server/config.yaml"

EXPOSE ${PORT}
