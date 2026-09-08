{ config, pkgs, ... }:

{

  home.packages = with pkgs; [ fish ];

  programs.fish = {
    enable = true;
    functions = {
      # Suppresses the default startup greeting
      fish_greeting = "";
    };
  };
}
