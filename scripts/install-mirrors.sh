#!/usr/bin/env bash
# Install Nix binary-cache mirrors into /etc/nix/nix.custom.conf (Determinate Nix).
# Run after installing Determinate Nix.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/modules/nix.custom.conf"
DEST=/etc/nix/nix.custom.conf

if [[ ! -d /etc/nix ]]; then
  echo "error: /etc/nix missing — install Determinate Nix first." >&2
  exit 1
fi

if [[ ! -f "$SRC" ]]; then
  echo "error: missing $SRC" >&2
  exit 1
fi

if [[ -e "$DEST" && ! -L "$DEST" ]]; then
  sudo mv "$DEST" "${DEST}.before-nix-darwin"
  echo "backed up existing file → ${DEST}.before-nix-darwin"
fi

sudo ln -sfn "$SRC" "$DEST"
echo "linked $DEST → $SRC"
nix show-config 2>/dev/null | grep -E '^substituters ' || true
