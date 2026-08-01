# agenix -r to re-key all secrets when adding a new key
# agenix -e <filename> to edit a secret (.age is appended automatically to the name in the `secrets` list)

let
  keys = [
    # battlestation
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtxZ1egOwwhoZv0leaAOLh4Xs9R4jFy7D7Rdesa1ArK"
    # mini
    # "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqABmNPDmjhatej1s3oCOIaFab2UFjU3scAngyVgWENX5Sq51v5NRQ1wJaB06MyRKjm3L3JbrecYGvDzR87b0vMxcfPmBtnaDOhnzWLtbMswJb1qfNhds8siVohmBq12W3IJfmXZnzsGwYimXC/eoRDwWsQwzcy7J1UD/UjhUXCB9dp20cwi/Fc0QAXcUL7Afk4zC5jbjah0UOnibZI2D96bOmLSEMwIGqMj6ZtGYZdeM9yXIP2HZ2V5O6ryXBG6a54ixy/zA2w4Rz/3h23cgXKHvrzp2f8PE8dI9VrJNKCmHdtSMBkAaIhhIZ9RwZlbzq2tmvN+Qia9vF1Ch+Jhi4c5TNzS3GVmPrSyIv5dqsN/Ea7Kx6nipvO027vvt0K98pe/eMNefDEVqrgRqaWO/xY/CckD0oF3SaNSB6hRzmu2zHuoWCgNEN/QbTboaxl2ELaOynln4KcWKMnnQQ+6ptto7Aup3f3fswlhlv0cO8YA5MWyOcq8GVPI/28iIsMSE="
    # dgb.sh
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFh97wdv2x0TtxnzPU6ZfdNAeleY7RvtV/f6lrTHfyQA"
    # teamspeak-server
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRAJwoisf2XTjW2lrGo4WcGV7gkBi3ryxDs8NZ6XKiv"
    # pi 4
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILOeEvZymnFYVFnwWj1a/ys2e4yGaOH9S/fLblbrJw7Z"
    # dgbmbp-nixos-vm
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmfX8OldvzJt2ia6yVFdjtmA0i7hjw4XDFeKoTgluPJ"
  ];

  # Decrypted filename - this is how the secret will appear in /run/agenix/
  # The file in this directory will be named SECRET.age if SECRET is in this list
  secrets = [
    "restic"

    "wireless.env"

    "ts3status.toml"

    "transmission-auth"

    "dgb.sh-dynamic-dns-password"

    "teamspeak-server-syncthing.key.pem"
    "teamspeak-server-syncthing.cert.pem"
    "mini-syncthing.key.pem"
    "mini-syncthing.cert.pem"
    "battlestation-syncthing.key.pem"
    "battlestation-syncthing.cert.pem"
    "dulu-syncthing.key.pem"
    "dulu-syncthing.cert.pem"
    "pi4-syncthing.key.pem"
    "pi4-syncthing.cert.pem"

    "netdata-discord.conf"

    "nix-cache-priv-key.pem"

    "atticd-env"

    "anki-password"

    "plex-token"

    "copyparty-dehowell"
    "copyparty-c"
    "copyparty-epiccookie"
    "copyparty-snacks"
    "copyparty-iris"
    "copyparty-dgb"
    "copyparty-siri"

    "miniflux-admin-creds"

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
