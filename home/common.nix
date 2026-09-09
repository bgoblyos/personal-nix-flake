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

  fonts.fontconfig.enable = true;

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
	comma
  ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5 --keep-one";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # Automatically injects 'z' into Fish
    
    # Enable fzf integration for interactive search ('zi')
    options = [ "--cmd z" ]; 
  };

  programs.fzf.enable = true;
}
