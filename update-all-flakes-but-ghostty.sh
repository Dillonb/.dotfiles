FLAKES=$(nix flake metadata --json ~/.dotfiles | jq -r '.locks.nodes.root.inputs | keys[] | select(. != "ghostty")')
echo "Updating flakes: $FLAKES"
nix flake update $FLAKES
