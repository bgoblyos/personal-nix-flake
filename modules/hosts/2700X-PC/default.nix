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
      inputs.home-manager.nixosModules.home-manager
      config.flake.modules.nixos."2700X-PC/configuration"
      config.flake.modules.nixos."2700X-PC/hardware"
      config.flake.modules.nixos."2700X-PC/mounts"
      config.flake.modules.nixos.gpg
      config.flake.modules.nixos.kvm
      config.flake.modules.nixos.plasma
      config.flake.modules.nixos.nvidia
      config.flake.modules.nixos.syncthing
      config.flake.modules.nixos.containers
      config.flake.modules.nixos.sdr
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
            config.flake.modules.homeManager.comma
            config.flake.modules.homeManager.julia
            ../../../home/common.nix
            ../../../home/apps/protonmail-bridge.nix
            ../../../home/apps/solaar.nix
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
