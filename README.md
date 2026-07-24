# searxng-docker

> **Ex umbris, veritas.**  
> _(Out of shadows, truth.)_

A self-hosted, privacy-respecting metasearch engine configured via Docker Compose for Arch Linux (Native or WSL).

## Repository Structure

```text
searxng/
├── .env.example
├── WSLBackgroundHost.ps1
├── docker-compose.yml
└── core-config/
    └── settings.yml
```

## Prerequisites & Docker Installation

Before deploying, ensure Docker and Docker Compose are installed on your Arch Linux environment, and your user account has non-root permission to manage Docker containers.

### 1. Install Docker & Docker Compose

In your Arch Linux terminal, update your packages and install the engine and Compose plugin:

```bash
sudo pacman -Syu docker docker-compose
```

### 2. Configure Non-Root Access

To run Docker commands without prepending `sudo` every time, add your user to the `docker` group:

```bash
sudo usermod -aG docker $USER
```

Enable and start the Docker daemon:

```bash
sudo systemctl enable --now docker.service
```

> **Important:** Log out and log back in (or run `newgrp docker`) for group membership changes to take effect. Verify by testing `docker run hello-world` without `sudo`.

## Environment Setup & Permissions

### 1. Configure `.env`

Copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

Generate a random 32-byte secret key using OpenSSL:

```bash
openssl rand -hex 32
```

Open `.env` in your editor and assign the generated key to `SEARXNG_SECRET`:

```bash
$EDITOR .env
```

### 2. Set Configuration Permissions

SearXNG runs inside the container under a non-root UID, which can cause the local `./core-config` directory to be reassigned to fallback user IDs (such as `systemd-coredump`) upon startup, leading to permission errors.

Set appropriate read/write access on the directory before starting the stack:

```bash
sudo chown -R $USER:$USER core-config
```

## Running SearXNG

1. Ensure you are inside the root directory of the repository:

```bash
cd /path/to/searxng
```

2. Start the services in detached mode:

```bash
docker compose up -d
```

3. Open your browser and navigate to:

```text
http://127.0.0.1:8080
```

## Windows Background Persistence (WSL Users Only)

When using WSL, Windows shuts down Linux instances when no active terminal windows remain open. To keep SearXNG running seamlessly in the background, use the provided `WSLBackgroundHost.ps1` script alongside Windows Task Scheduler.

### Setup Task Scheduler in Windows

1. Open **Task Scheduler** on Windows (`Win + R` -> type `taskschd.msc`).
2. Click **Create Basic Task...** on the right-side panel.
3. **Trigger:** Select **When I log on**.
4. **Action:** Select **Start a program**.
5. **Program/script:** Enter `powershell.exe`
6. **Add arguments:** Enter `-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\path\to\script\WSLBackgroundHost.ps1"`
7. **Start in:** `C:\path\to\script\`
8. Save and finish.
