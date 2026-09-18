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
      config.flake.modules.homeManager."suites/common"
      config.flake.modules.homeManager."suites/julia"
      config.flake.modules.homeManager.solaar
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
