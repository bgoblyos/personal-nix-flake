{
  inputs,
  config,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  flake.homeConfigurations."bence@7900-PC" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs; # Pass instantiated pkgs
    extraSpecialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.homeManager.fish
      config.flake.modules.homeManager.starship
      config.flake.modules.homeManager.git
      config.flake.modules.homeManager.gpg
      config.flake.modules.homeManager.comma
      ../../home/common.nix
      #../../home/apps/solaar.nix
      ../../home/scripts/winboot.nix
      {
        targets.genericLinux.enable = true;

        home.username = "bence";
        home.homeDirectory = "/home/bence";
        home.stateVersion = "26.05";

        home.sessionVariables = {
          NH_FLAKE = "/var/home/bence/Code/Nix/personal-nix-flake";
        };
      }
    ];
  };
}
