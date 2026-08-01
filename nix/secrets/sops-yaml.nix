{
  lib,
  runCommand,
  ssh-to-age,
}:
runCommand "sops.yaml" { nativeBuildInputs = [ ssh-to-age ]; } ''
  entries=(
  ${lib.concatStringsSep "\n" (
    lib.concatLists (
      lib.mapAttrsToList (
        group: members: lib.mapAttrsToList (name: key: "  '${group}/${name}|${key}'") members
      ) (import ./keys.nix)
    )
  )}
  )

  {
    echo "# Generated from nix/secrets/keys.nix by nix/secrets/sops-yaml.nix"
    echo "creation_rules:"
    echo '  - path_regex: nix/secrets/.*\.(yaml|json|env|ini|bin)$'
    echo "    key_groups:"
    echo "      - age:"
    for e in "''${entries[@]}"; do
      printf '          - %s # %s\n' \
        "$(printf '%s' "''${e#*|}" | ssh-to-age)" "''${e%%|*}"
    done
  } > $out
''
