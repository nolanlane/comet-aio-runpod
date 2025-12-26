# Comet All-In-One (RunPod Edition) - FIXED VERSION

## Critical Issues Fixed:

1. **Updated to latest Comet installation method** - Now uses `uv` package manager as required by the latest Comet version
2. **Fixed dependency management** - Removed manual pip installs that were causing conflicts
3. **Corrected startup method** - Uses `uv run python -m comet.main` instead of direct uvicorn
4. **Added health checks** - Both services now have health monitoring
5. **Enhanced debugging** - Better error reporting and service status

## Key Changes:

### Dockerfile Updates:
- Uses `uv sync` for proper dependency management
- Added verification step to ensure Comet can be imported
- Removed problematic manual dependency installations

### S6 Configuration Updates:
- `/root/etc/s6-overlay/s6-rc.d/comet/run` - Now uses official startup method
- Added health check scripts for both Comet and Prowlarr
- Enhanced error reporting and service monitoring

## Deployment Instructions:

### 1. Build and Test Locally (Optional)
```bash
docker build -t comet-aio-fixed .
docker run -p 8000:8000 -p 9696:9696 comet-aio-fixed
```

### 2. RunPod Deployment:
1. Use the updated image: `nolanlane/comet-aio:latest` (after rebuilding)
2. Set environment variables:
   ```
   INDEXER_MANAGER_URL=http://127.0.0.1:9696
   INDEXER_MANAGER_TYPE=prowlarr
   FASTAPI_HOST=0.0.0.0
   FASTAPI_PORT=8000
   CF_TUNNEL_TOKEN=your_token_here
   PROWLARR_API_KEY=your_prowlarr_api_key_here
   COMET_URL=https://comet.yourdomain.com
   ```
3. Expose ports 8000 and 9696
4. Deploy and monitor logs

### 3. Troubleshooting:
- Check pod logs for service startup status
- Verify Prowlarr starts first (port 9696)
- Comet will wait for Prowlarr before starting
- Health checks will restart failed services automatically

## Expected Behavior:
1. Prowlarr starts on port 9696
2. Comet waits for Prowlarr, then starts on port 8000
3. Cloudflared creates tunnels (if token provided)
4. Services are monitored and auto-restart on failure

This should resolve the startup issues you were experiencing on RunPod!
