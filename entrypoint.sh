#!/bin/bash
set -e

# Default values for user-configurable parameters
USERNAME="${USERNAME:-developer}"
PASSWORD="${PASSWORD:-password}"
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"

# Create the user and set password
if ! id -u "$USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo "User $USERNAME created with the specified password."
fi

# Ensure the workspace directory exists and set permissions
mkdir -p "$WORKSPACE_DIR"
chown -R "$USERNAME:$USERNAME" "$WORKSPACE_DIR"

# Run code-server as the specified user
exec su - "$USERNAME" -c "code-server $*"
