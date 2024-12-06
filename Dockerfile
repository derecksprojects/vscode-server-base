# Use a base Ubuntu image
FROM ubuntu:20.04

# Set environment variables to minimize user prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    zip \
    unzip \
    gnupg \
    software-properties-common \
    build-essential \
    && apt-get clean

# Install VS Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Set up the working directory
WORKDIR /workspace

# Create an entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the default VS Code server port
EXPOSE 8080

# Set the entrypoint script
ENTRYPOINT ["entrypoint.sh"]
CMD ["--bind-addr", "0.0.0.0:8080"]
