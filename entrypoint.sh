#!/bin/bash
set -e

# Generate SSL certificates if not exist
if [ ! -f /home/${USERNAME}/.ssl/key.pem ]; then
    mkdir -p /home/${USERNAME}/.ssl
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /home/${USERNAME}/.ssl/key.pem \
        -out /home/${USERNAME}/.ssl/cert.pem \
        -subj "/CN=localhost"
    chmod -R 600 /home/${USERNAME}/.ssl
fi

# Run code-server with specified environment variables
exec code-server --auth password --cert /home/${USERNAME}/.ssl/cert.pem --port ${PORT:-8443}
