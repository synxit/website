{
  description = "A flake for the synxit website, built with Zola and using the devlab theme.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };
  inputs.devlab-theme = {
    url = "git+https://codeberg.org/RiPetitor/devlab-theme";
    flake = false;
  };

  outputs =
    { nixpkgs, flake-utils, devlab-theme, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        themeName = ((builtins.fromTOML (builtins.readFile "${devlab-theme}/theme.toml")).name);
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.zola
          ];
        };
        packages.default = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "synxit-website";
          name = pname;
          version = "noversion";

          src = ./.;

          nativeBuildInputs = [
            pkgs.zola
            pkgs.cacert
          ];

          configurePhase = ''
            runHook preConfigure
            mkdir -p themes
            rm -rf themes/${themeName}
            cp -r --no-preserve=mode,ownership ${devlab-theme} themes/${themeName}
            runHook postConfigure
          '';

          buildPhase = ''
            runHook preBuild
            zola build --minify
            runHook postBuild
          '';
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r public/* $out/
            runHook postInstall
          '';
        };
      }
    );
}
