#!/usr/bin/env bash
set -euo pipefail
nix eval --raw --impure --expr "
(import ./nvidia-hashes.nix { version = \"${1:?usage: $0 <version>}\"; })
"
