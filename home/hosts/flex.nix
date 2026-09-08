{ pkgs, ... }:

{
  home.homeDirectory = "/var/home/bence";

  # Required for Fedora/OSTree environment integration
  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ../common.nix
  ];

  programs.git.package = null;

}
