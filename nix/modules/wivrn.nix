# WiVRn (OpenXR streaming), built from the commit matching the Steam Frame client CI build.
# Frame support (WiVRn PR #1130) isn't in a tagged release yet, and the headset client and
# server must be built from the same commit. Client: wivrn-frame-client.zip from
# https://github.com/WiVRn/WiVRn/actions/runs/37613847429
{ pkgs, ... }:

{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    # Lets async reprojection run at high priority
    highPriority = true;
    # Lets Proton games find WiVRn's OpenXR runtime (takes effect after logging out)
    steam.importOXRRuntimes = true;

    package = pkgs.wivrn.overrideAttrs (
      finalAttrs: old: {
        version = "26.9-unstable-2026-10-07";
        src = pkgs.fetchFromGitHub {
          owner = "WiVRn";
          repo = "WiVRn";
          rev = "640e1a540540edaef95b2270cfed3846c85887d4";
          hash = "sha256-lCwO4k/32pYZsjdR7R1tB56Hr2gLviUEmY9KS9Qw6HI=";
        };
        # Must match the monado-rev file in WiVRn's source at the commit above
        monado = pkgs.applyPatches {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "monado";
            repo = "monado";
            rev = "09741cbcb45236f4f4f79790ea133cd90d68d5eb";
            hash = "sha256-3+bdxyXHuaweT/K+Jwh428XNMuZUd1tL2bdFBRIZ/Po=";
          };
          postPatch = ''
            ${finalAttrs.src}/patches/apply.sh ${finalAttrs.src}/patches/monado/*
          '';
        };
      }
    );
  };
}
