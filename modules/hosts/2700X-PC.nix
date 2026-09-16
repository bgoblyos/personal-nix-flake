{
  config,
  inputs,
  ...
}: {
  #Ryzen 2700X-based workstation
  flake.nixosConfigurations."2700X-PC" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      ../../configuration.nix
      inputs.home-manager.nixosModules.home-manager
      config.flake.modules.nixos.gpg
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit inputs;};

        # Home Manager modules belong inside user imports
        home-manager.users.bence = {
          imports = [
            inputs.nix-index-database.homeModules.nix-index
            config.flake.modules.homeManager.fish
            config.flake.modules.homeManager.starship
            config.flake.modules.homeManager.git
            config.flake.modules.homeManager.gpg
            ../../home/common.nix
            ../../home/apps/protonmail-bridge.nix
            ../../home/apps/solaar.nix
            ({pkgs, ...}: {
              home = {
                homeDirectory = "/home/bence";
                packages = with pkgs; [
                  thunderbird
                  librewolf
                  keepassxc
                  uv
                  kicad
                  yt-dlp
                ];
              };
            })
          ];
        };
      }
    ];
  };
}
