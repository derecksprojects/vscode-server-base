#!/bin/bash

# Generate SSL certificates for HTTPS if they don't exist
if [ ! -f /home/${USERNAME}/.ssl/cert.pem ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /home/${USERNAME}/.ssl/key.pem \
        -out /home/${USERNAME}/.ssl/cert.pem \
        -subj "/CN=localhost" 
fi

# Ensure correct permissions
chmod 600 /home/${USERNAME}/.ssl/key.pem /home/${USERNAME}/.ssl/cert.pem

# Start code-server with proper configuration
exec code-server \
    --bind-addr 0.0.0.0:${PORT} \
    --auth password \
    --cert /home/${USERNAME}/.ssl/cert.pem \
    --cert-key /home/${USERNAME}/.ssl/key.pem