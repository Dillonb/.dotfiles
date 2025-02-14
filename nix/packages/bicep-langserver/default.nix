{ fetchFromGitHub, buildDotnetModule, lib, ... }:

let version = "0.33.93";
in
buildDotnetModule {
  pname = "bicep-langserver";
  version = version;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    rev = "v${version}";
    sha256 = "sha256-5XrFIgblr2WIMBPoVwRZ6X2dokbXw+nS8J7WzhHEzpU=";
  };

  nugetDeps = ./deps.json;

  projectFile = "src/Bicep.LangServer/Bicep.LangServer.csproj";

  meta = with lib; {
    description = "Bicep language server";
    license = licenses.mit;
  };
}
