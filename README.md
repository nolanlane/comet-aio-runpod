# Comet All-In-One (RunPod Edition)

Three services. One Pod. Zero friction.

*   **Prowlarr**: Indexer Manager (Starts first).
*   **Comet**: Stremio Addon (Waits for Prowlarr).
*   **Cloudflared**: Secure Tunnel (Exposes services).

## 1. Automated Build (CI/CD)

This repo includes a GitHub Action (`.github/workflows/docker-publish.yml`) that automatically builds and pushes to Docker Hub on every commit to `main`.

### Setup
1.  **Create Repo**: Push this code to a new GitHub repository.
2.  **Secrets**: Go to **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
    *   `DOCKER_USERNAME`: Your Docker Hub username.
    *   `DOCKER_PASSWORD`: Your Docker Hub Access Token (or password).
3.  **Push**: Commit and push. The Action will trigger and publish `yourusername/comet-aio:latest`.

## 2. RunPod Deploy

1.  Go to **RunPod** > **Deploy** > **CPU Pod**.
2.  Select **1 vCPU / 2-4 GB RAM** (Plenty for this stack).
3.  **Container Image**: `yourusername/comet-aio:latest`
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
