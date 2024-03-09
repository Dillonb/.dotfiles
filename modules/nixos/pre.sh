#!/usr/bin/env bash

NIXOS_CONFIG="/etc/nixos/configuration.nix"
NIXOS_CONFIG_DGB_BACKUP="/etc/nixos/configuration.nix.dgb-backup"


if [ ! -f $NIXOS_CONFIG ]
then
    echo "NixOS config did not exist. Creating a symlink. You may need to enter your password."
    sudo ln -vs $(pwd)/configuration.nix /etc/nixos/configuration.nix
else
    if [ ! -L $NIXOS_CONFIG ]
    then
        if [ -f $NIXOS_CONFIG_DGB_BACKUP ]
        then
            echo "Error: unable to backup NixOS config, a file at $NIXOS_CONFIG_DGB_BACKUP already exists!"
            exit 1
        else
            echo "NixOS config existed, but was not a symbolic link. Backing it up to $NIXOS_CONFIG_DGB_BACKUP and replacing it..."
            echo "You may need to enter your password."
            sudo mv -vn $NIXOS_CONFIG $NIXOS_CONFIG_DGB_BACKUP
            sudo ln -vs $(pwd)/configuration.nix $NIXOS_CONFIG
        fi
    else
        echo "NixOS config at $NIXOS_CONFIG already exists and is a symbolic link, assuming we're already set up. If this is wrong, delete the link and rerun this script."
    fi
fi
