{ ... }:
{
  users.groups.agenix = {};

  age.identityPaths = [
    "/home/dillon/.ssh/id_rsa"
  ];
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
  age.secrets."teamspeak-server-syncthing.key.pem" = {
    file = ./teamspeak-server-syncthing.key.pem.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."teamspeak-server-syncthing.cert.pem" = {
    file = ./teamspeak-server-syncthing.cert.pem.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."mini-syncthing.key.pem" = {
    file = ./mini-syncthing.key.pem.age;
    group = "agenix";
    mode = "440";
  };
  age.secrets."mini-syncthing.cert.pem" = {
    file = ./mini-syncthing.cert.pem.age;
    group = "agenix";
    mode = "440";
  };
}
