#!/usr/bin/env bash

# Generate the JSON list of all derivations
nix build ..#packages.x86_64-linux.all-nixos-systems --out-link all-nixos-systems.json
cat all-nixos-systems.json

mkdir -p systems-gcroots

jq -r -c '.[]' all-nixos-systems.json | while read -r i; do
    if [ -L "./systems-gcroots/$i" ]; then
        old_derivation=$(readlink -f "systems-gcroots/$i")
    fi

    toilet -f future "$i"
    nix build --cores 1 ..#nixosConfigurations."$i".config.system.build.toplevel --out-link systems-gcroots/"$i"

    if command -v nvd &>/dev/null; then
        if [ -n "$old_derivation" ]; then
            nvd diff "$old_derivation" "$(readlink -f "systems-gcroots/$i")"
        fi
    fi

done
