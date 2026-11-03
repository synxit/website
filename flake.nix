{
  description = "A flake for the synxit website, built with Zola and using the devlab theme.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    devlab-theme = {
      url = "git+https://codeberg.org/RiPetitor/devlab-theme";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      treefmt-nix,
      pre-commit-hooks,
      devlab-theme,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        themeName = ((builtins.fromTOML (builtins.readFile "${devlab-theme}/theme.toml")).name);
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks.update-page-date = {
            enable = true;
            name = "Update page dates";
            entry = "${pkgs.bash}/bin/bash .githooks/update-page-date";
            language = "system";
            files = "\\.md$";
            pass_filenames = true;
          };
        };
      in
      {
        checks.pre-commit-check = pre-commit-check;
        formatter = treefmtEval.config.build.wrapper;
        devShells.default = pkgs.mkShell {
          inherit (pre-commit-check) shellHook;
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
            zola build
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
