{ pkgs, ... }:

let
  discover-flatpak = pkgs.symlinkJoin
    {
      name = "discover-flatpak-backend";
      paths = [ pkgs.libsForQt5.discover ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak"
      '';
    };
in
{
  environment.systemPackages = [ discover-flatpak ];
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Flatpak applications can access fonts
  fonts.fontDir.enable = true;
}
