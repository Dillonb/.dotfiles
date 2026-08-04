{
  lib,
  buildNpmPackage,
  fetchurl,
  importNpmLock,
}:

let
  # The published tarball ships no lockfile, so vendor one generated with
  # `npm install --package-lock-only --ignore-scripts`. Its root entry mirrors
  # the upstream package.json, which importNpmLock also needs.
  packageLock = lib.importJSON ./package-lock.json;
in
buildNpmPackage (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.14";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${finalAttrs.version}.tgz";
    hash = "sha256-73UpjtOjVtyypN6Yxu/hCyrGSwBVYAcRi2rHBTXnMVY=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDeps = importNpmLock {
    inherit packageLock;
    package = packageLock.packages."";
    inherit (finalAttrs) pname version;
  };
  npmConfigHook = importNpmLock.npmConfigHook;

  # better-sqlite3 has no prebuilt binary in the sandbox, build it with node-gyp
  npmFlags = [ "--build-from-source" ];

  dontNpmBuild = true;

  meta = {
    description = "Headless command line client for Obsidian Sync and Obsidian Publish";
    homepage = "https://obsidian.md/help/headless";
    downloadPage = "https://www.npmjs.com/package/obsidian-headless";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "ob";
    platforms = lib.platforms.unix;
  };
})
