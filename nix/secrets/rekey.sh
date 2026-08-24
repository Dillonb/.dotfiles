#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

for f in *.yaml; do
  echo "rekeying $f"
  sops updatekeys -y "$f"
done
