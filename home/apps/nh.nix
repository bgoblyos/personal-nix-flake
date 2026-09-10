{ config, pkgs, ... }:

{

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5 --keep-one";
    };
  };

  home.sessionVariables = {
    NH_FLAKE = "git+ssh://git@github.com/bgoblyos/personal-nix-flake";
  };
  
}
