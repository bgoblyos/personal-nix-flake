{ pkgs, ... }:

{
  home.homeDirectory = "/home/bence";

  imports = [
    ../common.nix
	../apps/protonmail-bridge.nix
  ];

  # Install GUI packages
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.elisa
    thunderbird
    librewolf
    keepassxc
    uv
    kicad
    yt-dlp
  ];
}
