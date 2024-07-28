{ ... }:
{
  age.identityPaths = [
    "/home/dillon/.ssh/id_rsa"
  ];
  age.secrets."rclone.conf" = {
    file = ./rclone.conf.age;
    owner = "dillon";
  };
  age.secrets."restic" = {
    file = ./restic.age;
    owner = "dillon";
  };
}
