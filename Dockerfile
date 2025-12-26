# Base image: .NET 8 (Debian Bookworm) - Provides .NET runtime + Python 3.11
FROM mcr.microsoft.com/dotnet/aspnet:8.0-bookworm-slim

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PROWLARR_BRANCH="develop"
ENV S6_OVERLAY_VERSION=3.1.6.2
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    xz-utils \
    sqlite3 \
    libicu-dev \
    tar \
    git \
    procps \
    build-essential \
    python3-dev \
    libffi-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# --- S6 Overlay Installation ---
RUN curl -L -o /tmp/s6-overlay-noarch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    curl -L -o /tmp/s6-overlay-x86_64.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz" && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    rm -rf /tmp/*

# --- Cloudflared Installation ---
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm cloudflared.deb

# --- Prowlarr Installation ---
RUN mkdir -p /usr/bin/Prowlarr && \
    curl -L -o /tmp/prowlarr.tar.gz "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/updatefile?os=linux&runtime=netcore&arch=x64" && \
    tar -xzf /tmp/prowlarr.tar.gz -C /usr/bin/Prowlarr --strip-components=1 && \
    rm -rf /tmp/*

# --- Comet Installation ---
RUN git clone https://github.com/g0ldyy/comet /app/comet
WORKDIR /app/comet

# Install Python Dependencies manually
# CRITICAL FIX: Exclude 'asyncio' (built-in to Py3.11, breaks if installed from PyPI).
# We install dependencies explicitly to bypass pyproject.toml errors.
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir \
    aiohttp \
    aiosqlite \
    asyncpg \
    bencode-py \
    curl-cffi \
    databases \
    demagnetize \
    fastapi \
    gunicorn \
    jinja2 \
    loguru \
    mediaflow-proxy \
    orjson \
    pydantic-settings \
    python-multipart \
    rank-torrent-name \
    uvicorn

# --- Config Setup ---
RUN mkdir -p /config/prowlarr

# Copy S6 configuration
COPY root/ /

# Ports
EXPOSE 8000 9696

# Entrypoint
ENTRYPOINT ["/init"]
