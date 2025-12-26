# Comet All-In-One (RunPod Edition)

Three services. One Pod. Zero friction.

*   **Prowlarr**: Indexer Manager (Starts first).
*   **Comet**: Stremio Addon (Waits for Prowlarr).
*   **Cloudflared**: Secure Tunnel (Exposes services).

## 1. Automated Build (CI/CD)

This repo includes a GitHub Action (`.github/workflows/docker-publish.yml`) that automatically builds and pushes to Docker Hub on every commit to `main`.

### Setup
1.  **Repo Created**: https://github.com/nolanlane/comet-aio-runpod
2.  **Secrets Configured**: `DOCKER_USERNAME` and `DOCKER_PASSWORD` are set.
3.  **Automatic Builds**: Any push to `main` triggers a build and publish to `nolanlane/comet-aio:latest`.

## 2. Cloudflare Tunnel Setup (CRITICAL)

**The #1 cause of "502 Bad Gateway" errors is using `localhost` in the Cloudflare Dashboard.**
Docker containers handle `localhost` weirdly (IPv4 vs IPv6).

**You MUST use `127.0.0.1` explicitly.**

1.  Go to Cloudflare Zero Trust > Networks > Tunnels > Configure.
2.  **Public Hostname** (Comet):
    *   Subdomain: `comet`
    *   Service Type: `HTTP`
    *   URL: `127.0.0.1:8000`  <-- **NOT localhost**
3.  **Public Hostname** (Prowlarr):
    *   Subdomain: `prowlarr`
    *   Service Type: `HTTP`
    *   URL: `127.0.0.1:9696`  <-- **NOT localhost**

## 3. RunPod Deploy

1.  Go to **RunPod** > **Deploy** > **CPU Pod**.
2.  Select **1 vCPU / 2-4 GB RAM** (Plenty for this stack).
3.  **Container Image**: `nolanlane/comet-aio:latest` (Set Pull Policy to "Always").
4.  **Ports**: Expose `8000` and `9696`.
5.  **Edit Pod** > **Environment Variables**. Paste these:

    ```env
    INDEXER_MANAGER_URL=http://127.0.0.1:9696
    INDEXER_MANAGER_TYPE=prowlarr
    FASTAPI_HOST=0.0.0.0
    FASTAPI_PORT=8000
    CF_TUNNEL_TOKEN=eyJhIjoi... (Your Cloudflare Tunnel Token)
    PROWLARR_API_KEY= (Get this from Prowlarr UI after first run, then restart or set later)
    COMET_URL= (Your Cloudflare URL, e.g., https://comet.yourdomain.com)
    ```

6.  **Deploy**.

## 4. Post-Deploy

1.  Access Prowlarr locally or via your Cloudflare Tunnel to configure indexers.
2.  Comet will automatically start once Prowlarr is live.
