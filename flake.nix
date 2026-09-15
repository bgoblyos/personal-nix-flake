{
  description = "Personal Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);
  /*
    #
    # Ryzen 7900-based workstation
    homeConfigurations."bence@7900-PC" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [./home/hosts/7900-PC.nix nix-index-database.hmModules.nix-index];
    };

    # IdeaPad Flex 5 running kinoite
    homeConfigurations."bence@flex" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [./home/hosts/flex.nix nix-index-database.hmModules.nix-index];
    };
  };
  */
}
