# agenix -r to re-key all secrets when adding a new key
# agenix -e <filename> to edit a secret (.age is appended automatically to the name in the `secrets` list)

let
  keys = [
    # battlestation
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu32eRLkFV0Pa95ue1M0Nhs+G8H00jAKEkg9Aq7xSQ7aunlp6yfEw+iYpEOKN7ul6DR9VQEC/CP+NH7sL4iyjId0QU8lW/2SPe9Sn+XprnyEqMjUQCdQG1Yp6+No1BmlYFf1P8vKRff/qsxj9rN7lliwKF1eATJBhIuIEgddODTilbaGGv5aZVZCQ2Z/tZ7O/EAGjjeXwG39UYoF28scBca9A6H7Q1GvbsAd0pKS41S5HnJ+YEsNzLZNHc+btWw3ExUaUbmuJN6IdYB0ASKqKVdb67zo7B6QlCi6IVAIJRrj/6jK4D4vzCpdbW5EPcVKd0TT8AY5Ho27c6RFSuNHVp"
    # mini
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqABmNPDmjhatej1s3oCOIaFab2UFjU3scAngyVgWENX5Sq51v5NRQ1wJaB06MyRKjm3L3JbrecYGvDzR87b0vMxcfPmBtnaDOhnzWLtbMswJb1qfNhds8siVohmBq12W3IJfmXZnzsGwYimXC/eoRDwWsQwzcy7J1UD/UjhUXCB9dp20cwi/Fc0QAXcUL7Afk4zC5jbjah0UOnibZI2D96bOmLSEMwIGqMj6ZtGYZdeM9yXIP2HZ2V5O6ryXBG6a54ixy/zA2w4Rz/3h23cgXKHvrzp2f8PE8dI9VrJNKCmHdtSMBkAaIhhIZ9RwZlbzq2tmvN+Qia9vF1Ch+Jhi4c5TNzS3GVmPrSyIv5dqsN/Ea7Kx6nipvO027vvt0K98pe/eMNefDEVqrgRqaWO/xY/CckD0oF3SaNSB6hRzmu2zHuoWCgNEN/QbTboaxl2ELaOynln4KcWKMnnQQ+6ptto7Aup3f3fswlhlv0cO8YA5MWyOcq8GVPI/28iIsMSE="
    # dgb.sh
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDG/GPgoCBbnpDrf4hjtggYplH8zcc1gqPre/wjfe3ZqG2GT1ownC/iZ/7t6yGYlDA1IGecztNhaijvsjfqUjqBNwuAHmU2u+TJ8sDbdh2U8cw3ZNMpxPsGYsc8KjZSItErXG7RBazpsJKvWEgHK76cBz4ImY7V6Pw0R34CA4XIzR8mBC2v7xQHm9YgiomM7r7tKSGWKWuvGjVl7sE478BTLK1bfuy9v2MDdHmDy6ePE31P3ytbk3TjwYvVUrgYPMrf9yUuP+GMAGRFJ8JwYuzSgpVgUnrr6XQ2ded1VD97/I4Bsc9NE0Ju/H2lF/8HFcl28YfRTq/kzJ40Xo/oB5PHPSR370htyS/rNrP4hT26WKwzgh4kXvAZWXdbZFUtQqrBSOkVGAa20VjW9tbi6/AvbIihOSMbKWJqtbFjF+Ti/ALVsnuKsoYtWGD+/abcy57zfaHpG1yIen5qyqqAGU/wLjASjMYs5GQPCFz6kjk03rdm0WObrg93Z5b3FC2NyA8="
    # teamspeak-server
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCew9oqunRwsUtu/m8mcC1xh2Qmb6HMDGIPQgwNrGa5+SiQb8MYsnP7hsuGCMsGMHr/lL8x0rUj90ssTIE78iQONBP2KsnPv2ZuUoAYiEC/RRIC0atN5uR0zndGxNm8iTt03BpcWeDThngpr/B1ZW9g8K1MbTUrujaf7AU/wquXoLs/WpxkfDwq+2ZPOuE1en1ytSP/0E9c0Tq3HbJPp0Qp6a6OPrQT6G3pS1MtHmFaxJJFXvtvykMO87yb9cRdmOhQsXV3HajxHyXGy59qR0xVoC0QbdVHccW1JjhgBtO9hEMCGlXitOAFdYNqM1Gep+yt3TJ1HvQIKSKshy9oZHyjwYIv5w+potfYcQTW6PL5beZfv9T1CnYgWluzxHwRFebSUK/iuVHKI+583hzoVbfbglk2e5dL9rIJSgxg/RnvrrAEWdU/Ugt+XkiRZ7DifqDoaWdhIneCtSYOkx9aZAnICpFo4I3nPwOiGoGMbEuNV1o6Bhw7xcmzxorAGWecjW8="
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

    "ts3status.properties"
    "ts3status.dev.properties"
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

    "anki-password"

    "plex-token"

    "copyparty-dehowell"
    "copyparty-c"
    "copyparty-epiccookie"
    "copyparty-snacks"
    "copyparty-iris"
    "copyparty-dgb"

    "miniflux-admin-creds"
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
