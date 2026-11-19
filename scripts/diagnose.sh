#!/usr/bin/env bash
set -u
cd "$(dirname "$0")/.."
echo "== Host =="
uname -a
echo
echo "== KVM device =="
if [[ -e /dev/kvm ]]; then ls -l /dev/kvm; else echo "MISSING: /dev/kvm"; fi
echo
echo "== Docker =="
if command -v docker >/dev/null 2>&1; then docker version --format 'Client: {{.Client.Version}} / Server: {{.Server.Version}}' 2>&1; docker compose ps; else echo "Docker not installed"; fi
echo
echo "== VM logs (last 80 lines) =="
docker compose logs --tail=80 macos 2>&1 || true
