{ ... }:
{
  users = {
    users.dbeliveau = {
      name = "dbeliveau";
      home = "/Users/dbeliveau";
    };
  };

  ids.gids.nixbld = 30000;

  system.stateVersion = 5;
}
