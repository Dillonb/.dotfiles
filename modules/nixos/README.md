# Useful commands

## Rebuild from flake:
`nixos-rebuild switch --flake .#<hostname>`

## Build WSL tarball
`sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder`

This can then be imported on Windows with:

`wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2`

and then run with:

`wsl -d NixOS`

and set as the default with:

`wsl -s NixOS`
