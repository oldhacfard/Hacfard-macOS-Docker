# Hacfard macOS Docker

A Docker Compose deployment for a **real macOS virtual machine** managed from a custom Hacfard dashboard.

> **Important:** Docker is only the packaging layer. macOS runs as a QEMU virtual machine and requires a Linux host with working KVM access. The upstream VM image provides its own browser console; this project does not bundle or configure noVNC. The Hacfard dashboard is a custom management interface and securely proxies the upstream console.

## Features

- Real macOS guest VM through [dockur/macos](https://github.com/dockur/macos)
- Custom black / white / blue dashboard (no noVNC dependency in this repository)
- One-command setup and start
- Persistent VM disk in `./storage`
- Restart and recovery scripts that preserve VM data
- Console reverse-proxied through the dashboard on port 8080
- KVM preflight check and health/status display

## Requirements

- Linux host (bare metal or a VM with nested virtualization enabled)
- Docker Engine and Docker Compose v2
- `/dev/kvm` available to Docker
- AVX2-capable CPU
- Recommended: 8 GB RAM available and 64 GB free disk space

**Codespaces, many VPS providers, Docker Desktop on Windows 10, and hosts without nested KVM usually cannot run this VM.** A successful container build does not mean hardware virtualization is available.

## Quick start

```bash
git clone https://github.com/oldhacfard/Hacfard-macOS-Docker.git
cd Hacfard-macOS-Docker
chmod +x scripts/*.sh
./scripts/setup.sh
```

Open `http://HOST:8080`.

The first boot downloads Apple's recovery components and can take a while. Complete the macOS installer in the Console tab. In Disk Utility, erase the virtual disk as APFS, then install macOS. Keep the storage directory: it contains your VM disk.

## Configuration

Copy `.env.example` to `.env` and adjust:

| Variable | Default | Meaning |
|---|---:|---|
| `MACOS_VERSION` | `15` | macOS release selector supported by dockur/macos |
| `CPU_CORES` | `4` | VM CPU cores |
| `RAM_SIZE` | `8G` | VM memory |
| `DISK_SIZE` | `64G` | VM disk size |

Do not expose the raw VNC port to the public internet. Put the dashboard behind an authenticated HTTPS reverse proxy before remote access.

## Commands

```bash
docker compose up -d       # start
docker compose ps          # status
docker compose logs -f macos
./scripts/recover.sh       # restart VM without deleting its disk
docker compose down        # stop (keeps ./storage)
```

To fully reset the VM, stop the stack and manually remove `./storage`. This permanently deletes the installed guest OS and its data.

## Console note

The dashboard reverse-proxies the browser console exposed by the upstream `dockur/macos` image. It is not a separately implemented remote-display protocol. The project itself does not include noVNC assets or a noVNC service. If you require a fully custom display client (not the upstream console either), that needs a separate RFB/SPICE/WebRTC client implementation and is not claimed here.

## macOS licensing

This repository does not distribute macOS. Apple’s macOS licence restricts installation to Apple-branded hardware. Only install and run macOS where you are permitted to do so under Apple's current terms. See the upstream project's documentation and Apple's licence for details.

## Credits

- [dockur/macos](https://github.com/dockur/macos) — containerized QEMU macOS VM
- Hacfard — dashboard and deployment scripts
