{ config, pkgs, ... }:

{

  imports = [
    ./apps/nvim.nix
	./apps/fish.nix
	./apps/solaar.nix
	./apps/git.nix
	./apps/nh.nix
	./apps/fonts.nix
  ];

  home.username = "bence";
  home.stateVersion = "26.05";


  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
	comma
  ];
  
}
