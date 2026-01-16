#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export IMAGE_TAG="${IMAGE_TAG:-prod}"

FILES=(-f compose.prod.yml)

if [[ "${USE_TUNNEL:-0}" == "1" ]]; then
  FILES+=(-f compose.tunnel.yml)
fi

echo "[deploy] IMAGE_TAG=$IMAGE_TAG"
echo "[deploy] compose: ${FILES[*]}"

docker compose "${FILES[@]}" pull
docker compose "${FILES[@]}" up -d --remove-orphans

docker compose "${FILES[@]}" ps
