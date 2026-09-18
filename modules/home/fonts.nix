{
  flake.modules.homeManager.fonts = {
    config,
    pkgs,
    ...
  }: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [nerd-fonts.fira-code];
  };
}
