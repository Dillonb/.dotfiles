#!/usr/bin/env bash

if command -v chezmoi > /dev/null; then
  chezmoi -S "$(readlink -f ~/.dotfiles/chezmoi)" init
  chezmoi -S "$(readlink -f ~/.dotfiles/chezmoi)" apply
else
  if command -v nix-shell > /dev/null; then
    nix-shell -p chezmoi --command "chezmoi -S $(readlink -f ~/.dotfiles/chezmoi) init"
    nix-shell -p chezmoi --command "chezmoi -S $(readlink -f ~/.dotfiles/chezmoi) apply"
  else
    echo "Please install chezmoi."
    exit 1
  fi
fi
