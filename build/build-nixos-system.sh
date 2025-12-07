#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq toilet nvd

set -e

SYSTEM=$1

if [ -z "$SYSTEM" ]; then
    echo "Usage: $0 <nixos-system-name>"
    exit 1
fi

if [ -L "./systems-gcroots/$SYSTEM" ]; then
    old_derivation=$(readlink -f "systems-gcroots/$SYSTEM")
fi

toilet -f future "$SYSTEM"
nix build --show-trace --cores 8 ..#nixosConfigurations."$SYSTEM".config.system.build.toplevel --out-link systems-gcroots/"$SYSTEM"

if command -v nvd &>/dev/null; then
    if [ -n "$old_derivation" ]; then
        nvd diff "$old_derivation" "$(readlink -f "systems-gcroots/$SYSTEM")"
    fi
fi
