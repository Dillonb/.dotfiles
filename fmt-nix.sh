#!/usr/bin/env bash
# nixfmt --strict **/*.nix
find -type f -name '*.nix' -exec nixfmt --strict {} \;
