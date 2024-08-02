{ ... }:
{
  users.groups.agenix = {};

  age.identityPaths = [
    "/home/dillon/.ssh/id_rsa"
  ];
  age.secrets."rclone.conf" = {
    file = ./rclone.conf.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."restic" = {
    file = ./restic.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."ts3status.properties" = {
    file = ./ts3status.properties.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."ts3status.dev.properties" = {
    file = ./ts3status.dev.properties.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."resilio-rclone-config-secret" = {
    file = ./resilio-rclone-config-secret.age;
    group = "agenix";
    mode = "440";
  };
}
