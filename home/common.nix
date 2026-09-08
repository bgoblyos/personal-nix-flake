{ config, pkgs, ... }:

{

  imports = [
    ./apps/nvim.nix
	./apps/fish.nix
	./apps/solaar.nix
	./apps/git.nix
  ];

  home.username = "bence";
  home.stateVersion = "26.05";

}
