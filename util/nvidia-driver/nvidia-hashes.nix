{ version }:
let
  # File hash (for .run driver binaries fetched with nixpkgs fetchurl)
  fetchFileHash = url:
    builtins.convertHash {
      hash = builtins.hashFile "sha256" (builtins.fetchurl url);
      hashAlgo = "sha256";
      toHashFormat = "sri";
    };

  # NAR hash of unpacked tarball (for GitHub archives fetched with fetchFromGitHub/fetchzip)
  fetchTreeHash = url:
    (builtins.fetchTree { type = "tarball"; inherit url; }).narHash;

  sha256_64bit = fetchFileHash
    "https://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run";

  sha256_aarch64 = fetchFileHash
    "https://us.download.nvidia.com/XFree86/aarch64/${version}/NVIDIA-Linux-aarch64-${version}.run";

  openSha256 = fetchTreeHash
    "https://github.com/NVIDIA/open-gpu-kernel-modules/archive/${version}.tar.gz";

  settingsSha256 = fetchTreeHash
    "https://github.com/NVIDIA/nvidia-settings/archive/${version}.tar.gz";

  persistencedSha256 = fetchTreeHash
    "https://github.com/NVIDIA/nvidia-persistenced/archive/${version}.tar.gz";
in
''
config.boot.kernelPackages.nvidiaPackages.mkDriver {
  version = "${version}";
  sha256_64bit = "${sha256_64bit}";
  sha256_aarch64 = "${sha256_aarch64}";
  openSha256 = "${openSha256}";
  settingsSha256 = "${settingsSha256}";
  persistencedSha256 = "${persistencedSha256}";
}
''
