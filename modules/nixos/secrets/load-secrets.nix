{ ... }:
{
  age.identityPaths = [
    "/home/dillon/.ssh/id_rsa"
  ];
  age.secrets."rclone.conf".file = ./rclone.conf.age;
  age.secrets."restic".file = ./restic.age;
}
