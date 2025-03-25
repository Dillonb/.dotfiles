#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq toilet

# Generate the JSON list of all derivations
nix build ..#packages.x86_64-linux.all-nixos-systems --out-link all-nixos-systems.json
cat all-nixos-systems.json

mkdir -p systems-gcroots

jq -r -c '.[]' all-nixos-systems.json | while read -r i; do
    toilet -f future "$i"
    nix build --cores 1 ..#nixosConfigurations."$i".config.system.build.toplevel --out-link systems-gcroots/"$i"
done
