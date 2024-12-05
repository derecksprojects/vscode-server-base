#!/bin/bash
set -e

# Validate required environment variables
if [ -z "$USERNAME" ] || [ -z "$PORT" ] || [ -z "$PASSWORD" ]; then
    echo "Error: USERNAME, PORT, and PASSWORD environment variables are required"
    exit 1
fi

# Set HOME if not already set
if [ -z "$HOME" ]; then
    export HOME="/home/${USERNAME}"
fi

# Create user if it doesn't exist
if ! id -u ${USERNAME} >/dev/null 2>&1; then
    useradd -m -s /bin/bash ${USERNAME}
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}
fi

# Setup directories
mkdir -p ${HOME}/.local/share/code-server/extensions
mkdir -p ${HOME}/.local/share/code-server/User
mkdir -p ${HOME}/.local/share/code-server/Machine
mkdir -p ${HOME}/.local/share/code-server/logs
mkdir -p ${HOME}/.local/share/code-server/User/globalStorage
mkdir -p ${HOME}/.local/share/code-server/User/History
chown -R ${USERNAME}:${USERNAME} ${HOME}

# Generate SSL certificates if they don't exist
if [ ! -f /etc/code-server/self-signed.crt ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/code-server/self-signed.key \
        -out /etc/code-server/self-signed.crt \
        -subj "/CN=localhost"
fi

# Configure code-server
mkdir -p ${HOME}/.config/code-server
cat > ${HOME}/.config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:${PORT}
auth: password
password: ${PASSWORD}
cert: /etc/code-server/self-signed.crt
cert-key: /etc/code-server/self-signed.key
EOF

chown -R ${USERNAME}:${USERNAME} ${HOME}/.config

# Switch to the user and start code-server
exec sudo -u ${USERNAME} code-server \
    --bind-addr "0.0.0.0:${PORT}" \
    --user-data-dir "${HOME}/.local/share/code-server" \
    --config "${HOME}/.config/code-server/config.yaml"