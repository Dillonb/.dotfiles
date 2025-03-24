#!/usr/bin/env bash
#! nix-shell -i toilet jq


# Generate the JSON list of all derivations
# nix build --cores 1 ..#packages.x86_64-linux.all-nixos-systems --out-link all-nixos-systems.json
nix build ..#packages.x86_64-linux.all-nixos-systems --out-link all-nixos-systems.json
cat all-nixos-systems.json

mkdir -p systems-gcroots

nix-shell -p jq --command "jq -r -c '.[]' all-nixos-systems.json" | while read -r i; do
    nix-shell -p toilet --command "toilet -f future $i"
    nix build --cores 1 ..#nixosConfigurations."$i".config.system.build.toplevel --out-link systems-gcroots/"$i"
done
