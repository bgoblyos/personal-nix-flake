{ pkgs, ... }:

{
  home.homeDirectory = "/home/bence";

  # Required for Fedora/OSTree environment integration
  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ../common.nix
	../scripts/winboot.nix
  ];

  programs.git.package = null;

  home.sessionVariables = {
    NH_FLAKE = "/home/bence/Code/Nix/personal-nix-flake";
  };


}
