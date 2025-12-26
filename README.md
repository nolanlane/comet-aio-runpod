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

## 2. RunPod Deploy

1.  Go to **RunPod** > **Deploy** > **CPU Pod**.
2.  Select **1 vCPU / 2-4 GB RAM** (Plenty for this stack).
3.  **Container Image**: `nolanlane/comet-aio:latest`
4.  **Edit Pod** > **Environment Variables**. Paste these:

    ```env
    INDEXER_MANAGER_URL=http://127.0.0.1:9696
    CF_TUNNEL_TOKEN=eyJhIjoi... (Your Cloudflare Tunnel Token)
    PROWLARR_API_KEY= (Get this from Prowlarr UI after first run, then restart or set later)
    ```

5.  **Deploy**.

## 3. Post-Deploy

1.  Access Prowlarr locally or via your Cloudflare Tunnel to configure indexers.
2.  Comet will automatically start once Prowlarr is live.
