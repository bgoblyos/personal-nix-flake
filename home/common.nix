{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./apps/nvim.nix
    ./apps/nh.nix
    ./apps/fonts.nix
    ./scripts/nix-sync.nix
    ./scripts/pluto.nix
  ];

  home.username = "bence";
  home.stateVersion = "26.05";
}
