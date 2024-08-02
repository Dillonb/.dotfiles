{ ... }:
let
  secrets = import ./secrets.nix;
  secret-filenames = builtins.attrNames secrets;
  secretsAttrList = map (secret-filename: {
    name = secrets."${secret-filename}".decryptedFilename;
    value = {
      file = (./. + "/${secret-filename}");
      group = "agenix";
      mode = "440";
    };
  }) secret-filenames;
in
{
  users.groups.agenix = {};

  age.identityPaths = [
    "/home/dillon/.ssh/id_rsa"
  ];

  age.secrets = builtins.listToAttrs secretsAttrList;
}
