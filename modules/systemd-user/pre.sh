#!/usr/bin/env bash
pushd services

for service in *; do
    ln -f $(pwd)/$service $HOME/.config/systemd/user/$service
done

popd
