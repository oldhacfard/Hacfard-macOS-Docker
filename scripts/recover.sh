#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
if ! command -v docker >/dev/null 2>&1; then echo "Docker is not installed."; exit 1; fi
if [[ ! -e /dev/kvm ]]; then echo "KVM is unavailable: /dev/kvm not found."; exit 1; fi
echo "Restarting the macOS VM container. Persistent storage will be kept."
docker compose restart macos
echo "Recovery restart requested. Check: docker compose logs -f macos"
