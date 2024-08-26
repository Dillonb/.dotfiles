{ config, ... }:
let
  secrets = import ./secrets.nix;
  secret-filenames = builtins.attrNames secrets;
  secretsAttrList = map
    (secret-filename: {
      name = secrets."${secret-filename}".decryptedFilename;
      value = {
        file = (./. + "/${secret-filename}");
        group = "agenix";
        mode = "440";
      };
    })
    secret-filenames;
in
{
  users.groups.agenix = { };

  # Paths to private keys to look for at runtime. The default is just the hostKeys.
  # But it's necessary to add them to the list again if we're overriding it here.
  age.identityPaths = (map (key: key.path) config.services.openssh.hostKeys)
    ++ [ "/home/dillon/.ssh/id_rsa" ];

  age.secrets = builtins.listToAttrs secretsAttrList;
}
