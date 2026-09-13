{pkgs, ...}: {
  home.homeDirectory = "/home/bence";

  imports = [
    ../common.nix
    ../apps/protonmail-bridge.nix
    ../apps/solaar.nix
  ];

  # Install GUI packages
  home.packages = with pkgs; [
    thunderbird
    librewolf
    keepassxc
    uv
    kicad
    yt-dlp
  ];

  home.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };
}
