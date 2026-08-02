# agenix -r to re-key all secrets when adding a new key
# agenix -e <filename> to edit a secret (.age is appended automatically to the name in the `secrets` list)

let
  keys = builtins.concatLists (map builtins.attrValues (builtins.attrValues (import ./keys.nix)));

  # Decrypted filename - this is how the secret will appear in /run/agenix/
  # The file in this directory will be named SECRET.age if SECRET is in this list
  secrets = [
    "restic"

    "wireless.env"

    "ts3status.toml"

    "netdata-discord.conf"

    "nixos-unstable-discord-webhook"
  ];

  secretsAttrList = map (filename: {
    name = "${filename}.age";
    value = {
      publicKeys = keys;
      decryptedFilename = filename;
    };
  }) secrets;
in
builtins.listToAttrs secretsAttrList
