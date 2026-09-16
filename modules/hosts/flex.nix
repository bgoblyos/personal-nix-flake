{
  inputs,
  config,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  flake.homeConfigurations."bence@flex" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs; # Pass instantiated pkgs
    extraSpecialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.homeManager.fish
      config.flake.modules.homeManager.starship
      config.flake.modules.homeManager.git
      config.flake.modules.homeManager.gpg
      ../../home/common.nix
      ../../home/apps/solaar.nix
      {
        targets.genericLinux.enable = true;

        home.username = "bence";
        home.homeDirectory = "/var/home/bence";
        home.stateVersion = "26.05";

        home.sessionVariables = {
          NH_FLAKE = "/var/home/bence/Code/Nix/personal-nix-flake";
        };
      }
    ];
  };
}
