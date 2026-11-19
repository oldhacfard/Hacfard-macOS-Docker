#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
echo "== Hacfard macOS Docker setup =="
if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ERROR: A Linux host with KVM is required. This script cannot enable KVM in Codespaces or Docker Desktop."
  exit 1
fi
if [[ ! -e /dev/kvm ]]; then
  echo "ERROR: /dev/kvm is missing. Enable hardware virtualization/nested virtualization and use a KVM-capable Linux host."
  exit 1
fi
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker Engine is not installed."
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "ERROR: Docker Compose v2 is required."
  exit 1
fi
if [[ ! -f .env ]]; then cp .env.example .env; echo "Created .env from defaults."; fi
mkdir -p storage
chmod +x scripts/*.sh
echo "Starting services..."
docker compose pull
docker compose up -d
echo
echo "Dashboard: http://localhost:$(grep -E '^DASHBOARD_PORT=' .env | cut -d= -f2 || echo 8080)"
echo "VM logs: docker compose logs -f macos"
