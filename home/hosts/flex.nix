{ pkgs, ... }:

{
  home.homeDirectory = "/var/home/bence";

  # Required for Fedora/OSTree environment integration
  targets.genericLinux.enable = true;

  imports = [
    ../common.nix
  ];

  programs.git.package = null;
  programs.fish.package = null;
  programs.nvim.package = null;

}
