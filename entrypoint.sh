#!/bin/bash

# Generate SSL certificates for HTTPS
if [ ! -f /home/${USERNAME}/.ssl/cert.pem ]; then
  mkdir -p /home/${USERNAME}/.ssl
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /home/${USERNAME}/.ssl/key.pem \
    -out /home/${USERNAME}/.ssl/cert.pem \
    -subj "/CN=localhost"
fi

# Start code-server
exec code-server --bind-addr 0.0.0.0:${PORT} --auth password --cert /home/${USERNAME}/.ssl/cert.pem --cert-key /home/${USERNAME}/.ssl/key.pem
