{
  flake.modules.homeManager.protonmail-bridge = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [protonmail-bridge-gui];

    services.protonmail-bridge.enable = true;
  };
}
