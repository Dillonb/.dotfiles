#!/usr/bin/env bash
if ! [[ -f ~/.zshrc_local ]]; then
    touch ~/.zshrc_local
fi

pushd ~/.oh-my-zsh
echo "Updating oh-my-zsh..."
git pull
popd
