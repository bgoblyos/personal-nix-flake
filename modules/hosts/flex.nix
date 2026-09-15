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
      ../../home/common.nix
      ../../home/apps/solaar.nix
      {
        home.username = "bence";
        home.homeDirectory = "/var/home/bence";
        home.stateVersion = "26.05";

        programs.git.package = null;

        home.sessionVariables = {
          NH_FLAKE = "/var/home/bence/Code/Nix/personal-nix-flake";
        };
      }
    ];
  };
}
