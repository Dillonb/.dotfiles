{
  config,
  lib,
  pkgs,
  ...
}:

let
  steam-run-proton = pkgs.writeShellApplication {
    name = "steam-run-proton";
    runtimeInputs = [
      config.programs.steam.package.run
      pkgs.coreutils
    ];
    text = ''
      if [[ $# -lt 1 ]]; then
        echo "usage: steam-run-proton <program.exe> [args...]" >&2
        exit 1
      fi

      exe=$(realpath "$1")
      shift

      # steam-run's FHS environment gets a private /tmp, so anything under it is
      # invisible to Proton.
      if [[ "$exe" == /tmp/* ]]; then
        echo "steam-run-proton: $exe is under /tmp, which steam-run hides" >&2
        exit 1
      fi

      prefix="$HOME/.local/share/steam-run-proton"
      mkdir -p "$prefix"

      export STEAM_COMPAT_DATA_PATH="$prefix"
      export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/root"

      proton=${pkgs.proton-ge-bin.steamcompattool}/proton

      # This is just here to ensure the prefix exists and is updated
      # (runinprefix doesn't create or update a prefix)
      if ! setup=$(steam-run "$proton" getnativepath 'c:\windows' 2>&1); then
        echo "$setup" >&2
        exit 1
      fi

      exec steam-run "$proton" runinprefix "$exe" "$@"
    '';
  };
in
{
  environment.systemPackages = lib.mkIf config.programs.steam.enable [ steam-run-proton ];
}
