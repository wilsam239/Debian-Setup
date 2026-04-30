# Server Setup Script

A bootstrapping script for setting up a Ubuntu server (or desktop) with a full development and hosting environment for Play Framework / Scala applications.

## Usage

**Server / CLI mode** (no GUI apps):
```bash
./install.sh
```

**Desktop / UI mode** (includes GUI apps like Discord, VS Code, VLC):
```bash
./install.sh --ui
```

## What It Installs

### System
- Full system update (`apt update && upgrade`)

### Core Tools
- `curl`, `git`, `build-essential`, `ufw`, `snapd`

### Languages & Runtimes
| Tool | Version | Notes |
|------|---------|-------|
| Java | 21 (LTS) | via `openjdk-21-jdk` |
| Python | 3 | includes `pip` |
| AWS CLI | latest | installed via pip |
| Node.js | LTS | managed via NVM |

### Web & Hosting
- **Nginx** — web server, enabled on startup
- **Certbot** — SSL certificate management via Let's Encrypt

### Application
- **sbt** — Scala build tool for Play Framework projects

### Database
- **PostgreSQL** — with `postgresql-contrib`, enabled on startup

### Remote Access
- **OpenSSH** — SSH server, enabled on startup
- **WireGuard** — VPN, keypair generation left to you post-install

### Firewall (UFW)
| Rule | Purpose |
|------|---------|
| OpenSSH | SSH access |
| Nginx Full | HTTP (80) + HTTPS (443) |
| 9000 | Play Framework dev port |

### UI Apps (--ui mode only)
- Discord
- Firefox
- Sublime Text
- VLC
- VS Code

## After Running

The script will remind you of these steps on completion:

1. **WireGuard** — generate your keypair and configure `/etc/wireguard/wg0.conf`:
   ```bash
   wg genkey | tee privatekey | wg pubkey > publickey
   ```
   See the [WireGuard quickstart](https://www.wireguard.com/quickstart/) for full setup.

2. **Router** — forward UDP port `51820` for WireGuard, and TCP port `22` for SSH (or tunnel SSH over WireGuard instead).

3. **Nginx** — configure a reverse proxy to point to your Play app:
   ```nginx
   location / {
       proxy_pass http://127.0.0.1:9001;
   }
   ```

4. **PostgreSQL** — create your app's database and user:
   ```bash
   sudo -u postgres psql
   ```

5. **AWS** — configure your credentials:
   ```bash
   aws configure
   ```

## Requirements

- Ubuntu 22.04+ (tested on Ubuntu 24.04)
- Run as a user with `sudo` access
- Internet access for package downloads
