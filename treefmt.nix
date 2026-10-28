{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs.taplo.enable = true;

  programs.djlint = {
    enable = true;
    package = pkgs.djlint;

  };

  settings.formatter.djlint = {
    options = [
      "--profile"
      "tera"
    ];
  };

  programs.nixfmt = {
    enable = true;
  };

}
