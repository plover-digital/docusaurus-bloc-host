FROM node:20-bullseye-slim
LABEL org.opencontainers.image.description="Docusaurus Podman container - builds and serves a Docusaurus site from a mounted markdown docs folder"

ENV DOCS_DIR=/docs \
    SITE_DIR=/site \
    PORT=3000 \
    MODE=build

WORKDIR /app

# Install minimal system deps required for npm installs and git fetching
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates build-essential python3 && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint and make executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Lightweight static server for the built site
RUN npm install -g http-server

EXPOSE 3000
VOLUME ["/docs"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
