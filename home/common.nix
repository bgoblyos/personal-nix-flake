{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./apps/nvim.nix
    ./apps/fish.nix
    ./apps/starship.nix
    ./apps/git.nix
    ./apps/nh.nix
    ./apps/fonts.nix
    ./scripts/nix-sync.nix
    ./scripts/pluto.nix
  ];

  home.username = "bence";
  home.stateVersion = "26.05";

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-index-database.comma.enable = true;
}
