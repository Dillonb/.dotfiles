#!/usr/bin/env bash
set -euo pipefail

gh workflow run update-flake-lock.yml --repo Dillonb/.dotfiles
