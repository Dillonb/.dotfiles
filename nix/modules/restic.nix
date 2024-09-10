{ pkgs, ... }:
{
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "dillon";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };
}
