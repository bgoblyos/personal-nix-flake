{
  description = "Personal Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Ryzen 2700X-based workstation
	nixosConfigurations."2700X-PC" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bence = import ./home/hosts/2700X-PC.nix;
        }
      ];
    };

	# Ryzen 7900-based workstation
    homeConfigurations."bence@7900-PC" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./home/hosts/7900-PC.nix ];
    };

    # IdeaPad Flex 5 running kinoite
    homeConfigurations."bence@flex" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./home/hosts/flex.nix ];
    };
  };
}
