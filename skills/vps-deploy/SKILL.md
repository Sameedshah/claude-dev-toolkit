---
name: vps-deploy
description: VPS deployment workflow for Hostinger and similar providers. This skill should be used when deploying a Node.js/Next.js application to a VPS via SSH and rsync, setting up PM2 process management, configuring Nginx reverse proxy, or troubleshooting a failed deployment. Enforces a pre-deploy checklist before any file transfer, and provides rollback steps. Works alongside the deploy-agent which automates execution.
---

# VPS Deploy

## Overview

Safe, repeatable VPS deployment for Node.js applications. Always runs a pre-deploy checklist. Never deploys with a dirty git tree. Uses rsync + PM2 + Nginx as the standard stack.

**Automated execution:** use the `deploy-agent` to run these steps. This skill defines the pattern and rules.

## Required Environment Variables

All must be in `.env` (never hardcoded):

| Variable | Purpose |
|----------|---------|
| `VPS_USER` | SSH username (e.g. `root` or `deploy`) |
| `VPS_HOST` | VPS IP or hostname |
| `VPS_PATH` | Absolute path on VPS (e.g. `/var/www/myapp`) |
| `APP_NAME` | PM2 process name |
| `DOMAIN` | Production domain for health check |

## Pre-Deploy Checklist (Non-Negotiable)

Run ALL checks before any file transfer:

- [ ] `npm run build` exits 0
- [ ] Test suite passes (run project test command)
- [ ] `git status --porcelain` returns empty (clean tree)
- [ ] `.env` exists and contains all required vars
- [ ] VPS SSH connection works: `ssh $VPS_USER@$VPS_HOST "echo ok"`

If any check fails — **stop, do not deploy**.

## Deploy Steps

```bash
# 1. Load env
source .env

# 2. Build
npm run build

# 3. Sync (exclude secrets and dev files)
rsync -avz \
  --exclude='.env' \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='.specify' \
  --exclude='obsidian' \
  ./dist/ ${VPS_USER}@${VPS_HOST}:${VPS_PATH}/

# 4. Install prod dependencies on server
ssh ${VPS_USER}@${VPS_HOST} "cd ${VPS_PATH} && npm ci --omit=dev"

# 5. Restart via PM2
ssh ${VPS_USER}@${VPS_HOST} "pm2 restart ${APP_NAME} || pm2 start dist/server.js --name ${APP_NAME}"

# 6. Health check (wait for process to stabilise)
sleep 5
curl -f https://${DOMAIN}/health && echo "Deploy OK" || { echo "DEPLOY FAILED"; exit 1; }
```

## Rollback

```bash
source .env
ssh ${VPS_USER}@${VPS_HOST} "cd ${VPS_PATH} && git checkout HEAD~1 && npm ci --omit=dev && pm2 restart ${APP_NAME}"
```

## Nginx Config Template

```nginx
server {
  listen 80;
  server_name example.com;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl;
  server_name example.com;

  ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

  location / {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
```

## PM2 Ecosystem File

```js
// ecosystem.config.js
module.exports = {
  apps: [{
    name: process.env.APP_NAME || 'app',
    script: 'dist/server.js',
    env_production: { NODE_ENV: 'production' },
    max_restarts: 5,
    restart_delay: 3000,
  }]
}
```

## Common Issues

| Symptom | Fix |
|---------|-----|
| Health check 502 | PM2 process crashed — check `pm2 logs $APP_NAME` on VPS |
| rsync permission denied | SSH key not added to VPS — run `ssh-copy-id $VPS_USER@$VPS_HOST` |
| Build fails on server | Node version mismatch — use `nvm` to match local version |
| PM2 not found | Run `npm install -g pm2` on VPS first |
